--Przykład 1 -ST_Intersects
CREATE TABLE sobol.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';

--1.dodanie serial primary key:
alter table tarnawa.intersects
add column rid SERIAL PRIMARY KEY;

--2.utworzenie indeksu przestrzennego
CREATE INDEX idx_intersects_rast_gist ON sobol.intersects
USING gist (ST_ConvexHull(rast));

--3.dodanie raster constraints:
SELECT AddRasterConstraints('sobol'::name,'intersects'::name,'rast'::name);

--Przykład 2 -ST_Clip
CREATE TABLE sobol.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';

--Przykład 3 -ST_Union
CREATE TABLE sobol.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);

--Przykład 1 -ST_AsRaster
CREATE TABLE sobol.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--Przykład 2 -ST_Union
DROP TABLE sobol.porto_parishes; 
CREATE TABLE sobol.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--Przykład3 -ST_Tile
DROP TABLE sobol.porto_parishes; 
CREATE TABLE sobol.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1 
)
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--Przykład 1 -ST_Intersection
CREATE TABLE sobol.intersection as
SELECT a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--Przykład 2 -ST_DumpAsPolygons
CREATE TABLE sobol.dumppolygons AS
SELECT a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--Przykład 1 -ST_Band
CREATE TABLE sobol.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;

--Przykład 2 -ST_Clip
CREATE TABLE sobol.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--Przykład 3 -ST_Slope
CREATE TABLE sobol.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM tarnawa.paranhos_dem AS a;

--Przykład 4 -ST_Reclass
CREATE TABLE sobol.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
FROM sobol.paranhos_slope AS a;

--Przykład 5 -ST_SummaryStats
SELECT ST_SummaryStats(a.rast) AS stats
FROM sobol.paranhos_dem AS a;

--Przykład 6 -ST_SummaryStats orazUnio
SELECT ST_SummaryStats(ST_Union(a.rast))
FROM sobol.paranhos_dem AS a;

--Przykład7 -ST_SummaryStats z lepszą kontrolą złożonego typu danych
WITH t AS (
SELECT ST_SummaryStats(ST_Union(a.rast)) AS stats
FROM sobol.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;


-- Przykład8 ST_SummaryStats w połączeniu z GROUP BY
WITH t AS (
SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) AS stats
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;

--Przykład 9 -ST_Value
SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom) AS wartosc_piksela
FROM
rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;

--Przykład 10 -ST_TPI
CREATE TABLE sobol.tpi30 as
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem a;

CREATE INDEX idx_tpi30_rast_gist ON sobol.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('sobol'::name, 'tpi30'::name,'rast'::name);

--Przykład 1 -Wyrażenie Algebry Map
CREATE TABLE sobol.porto_ndvi AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, 1,
r.rast, 4,
'([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF'
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON sobol.porto_ndvi
USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('sobol'::name, 'porto_ndvi'::name,'rast'::name);

--Przykład2 –Funkcja zwrotna
CREATE OR REPLACE FUNCTION sobol.ndvi(
VALUE double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); 
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;


CREATE TABLE sobol.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'sobol.ndvi(double precision[], integer[],text[])'::regprocedure,
'32BF'::text
FROM r;
	
CREATE INDEX idx_porto_ndvi2_rast_gist ON sobol.porto_ndvi2
USING gist (ST_ConvexHull(rast));
SELECT AddRasterConstraints('sobol'::name, 'porto_ndvi2'::name,'rast'::name);

--Przykład 1 -ST_AsTiff
SELECT ST_AsTiff(ST_Union(rast))
FROM sobol.porto_ndvi;
	
--Przykład 2 -ST_AsGDALRaster	
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM sobol.porto_ndvi;

--Przykład 3 -Zapisywanie danych na dysku za pomocą dużego obiektu (large object, lo)
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM sobol.porto_ndvi;

SELECT lo_export(loid, 'C:\myraster.tiff') 
FROM tmp_out; 
SELECT lo_unlink(loid)
FROM tmp_out;

gdal_translate -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9
	PG:"host=localhost port=5432 dbname=a_raster user=postgres password=*** schema=sobol table=porto_ndvi mode=2" porto_ndvi.tiff