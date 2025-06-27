-- Problem1: Create master view using the microsoft sql server (I did not write it from scratch)
SELECT       dbo.VehicleDetails.ID, dbo.VehicleDetails.MakeID, dbo.Makes.Make, dbo.VehicleDetails.ModelID, dbo.MakeModels.ModelName, dbo.VehicleDetails.SubModelID, dbo.SubModels.SubModelName, dbo.VehicleDetails.BodyID, 
                         dbo.Bodies.BodyName, dbo.VehicleDetails.Vehicle_Display_Name, dbo.VehicleDetails.Year, dbo.VehicleDetails.DriveTypeID, dbo.DriveTypes.DriveTypeName, dbo.VehicleDetails.Engine, dbo.VehicleDetails.Engine_CC, 
                         dbo.VehicleDetails.Engine_Cylinders, dbo.VehicleDetails.Engine_Liter_Display, dbo.VehicleDetails.FuelTypeID, dbo.FuelTypes.FuelTypeName, dbo.VehicleDetails.NumDoors
FROM            dbo.FuelTypes INNER JOIN
                         dbo.Bodies INNER JOIN
                         dbo.Makes INNER JOIN
                         dbo.MakeModels ON dbo.Makes.MakeID = dbo.MakeModels.MakeID INNER JOIN
                         dbo.SubModels ON dbo.MakeModels.ModelID = dbo.SubModels.ModelID INNER JOIN
                         dbo.VehicleDetails ON dbo.Makes.MakeID = dbo.VehicleDetails.MakeID AND dbo.MakeModels.ModelID = dbo.VehicleDetails.ModelID AND dbo.SubModels.SubModelID = dbo.VehicleDetails.SubModelID ON 
                         dbo.Bodies.BodyID = dbo.VehicleDetails.BodyID INNER JOIN
                         dbo.DriveTypes ON dbo.VehicleDetails.DriveTypeID = dbo.DriveTypes.DriveTypeID ON dbo.FuelTypes.FuelTypeID = dbo.VehicleDetails.FuelTypeID

select * from VehicleMasterDetails;


-- Problem 2: Get all vehicles made between 1950 and 2000
select * from VehicleDetails
where year between 1950 and 2000;


-- Problem 3 : Get number vehicles made between 1950 and 2000
select count(*) as NumberOfVehicles from VehicleDetails
where year between 1950 and 2000;


-- Problem 4 : Get number vehicles made between 1950 and 2000 per make and order them by Number Of Vehicles Descending
SELECT       Makes.Make, NumberOfVehicles = COUNT(*)
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE		 (VehicleDetails.year between 1950 and 2000)
GROUP BY	Makes.Make
ORDER BY NumberOfVehicles desc;


-- Problem 5 : Get All Makes that have manufactured more than 12000 Vehicles in years 1950 to 2000
-- Using having
SELECT       Makes.Make, NumberOfVehicles = COUNT(*)
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE		 (VehicleDetails.year between 1950 and 2000)
GROUP BY	Makes.Make
having COUNT(*) > 12000
ORDER BY NumberOfVehicles desc;

-- Without using having
select * from (
	SELECT       Makes.Make, NumberOfVehicles = COUNT(*)
	FROM            VehicleDetails INNER JOIN
							 Makes ON VehicleDetails.MakeID = Makes.MakeID
	WHERE		 (VehicleDetails.year between 1950 and 2000)
	GROUP BY	Makes.Make
) newTable
where NumberOfVehicles > 12000
order by NumberOfVehicles desc;


-- Problem 6: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside
SELECT       Makes.Make, NumberOfVehicles = COUNT(*), (select COUNT(*) from VehicleDetails) as TotalVehicles
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE		 (VehicleDetails.year between 1950 and 2000)
GROUP BY	Makes.Make
ORDER BY NumberOfVehicles desc;


-- Problem 7: Get number of vehicles made between 1950 and 2000 per make and add total vehicles column beside it, then calculate it's percentage
SELECT       Makes.Make, NumberOfVehicles = COUNT(*), (select COUNT(*) from VehicleDetails) as TotalVehicles, Prec = ((COUNT(*) * 1.0)/(select COUNT(*) from VehicleDetails))
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE		 (VehicleDetails.year between 1950 and 2000)
GROUP BY	Makes.Make
ORDER BY NumberOfVehicles desc;

-- Another way
select *, Perc = (cast(NumberOfVehicles as float) / cast(TotalVehicles as float)) from
(
	SELECT       Makes.Make, NumberOfVehicles = COUNT(*), (select COUNT(*) from VehicleDetails) as TotalVehicles
	FROM            VehicleDetails INNER JOIN
							 Makes ON VehicleDetails.MakeID = Makes.MakeID
	WHERE		 (VehicleDetails.year between 1950 and 2000)
	GROUP BY	Makes.Make
) newTable3
order by NumberOfVehicles desc;


-- Problem 8: Get Make, FuelTypeName and Number of Vehicles per FuelType per Make
SELECT       Makes.Make, FuelTypes.FuelTypeName, COUNT(*) as NumberOfVehicles
FROM				VehicleDetails INNER JOIN
					Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
                         FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
WHERE		 (VehicleDetails.year between 1950 and 2000)
group by Makes.Make, FuelTypes.FuelTypeName
order by Makes.Make;


-- Problem 9: Get all vehicles that runs with GAS
SELECT       VehicleDetails.*, FuelTypes.FuelTypeName
FROM            VehicleDetails INNER JOIN
                         FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where FuelTypes.FuelTypeName = N'GAS'; -- The N before the 'Gas' is for unicode since the type of the field is nvarchar.


-- Problem 10: Get all Makes that runs with GAS
SELECT       Makes.Make, FuelTypes.FuelTypeName
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
                         FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
where FuelTypes.FuelTypeName = N'GAS';


-- Problem 11: Get Total Makes that runs with GAS
select COUNT(*) as TotalMakesRunsOnGas from
(
	SELECT       distinct Makes.Make, FuelTypes.FuelTypeName
	FROM            VehicleDetails INNER JOIN
							 Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
							 FuelTypes ON VehicleDetails.FuelTypeID = FuelTypes.FuelTypeID
	where FuelTypes.FuelTypeName = N'GAS'
) newTable;


-- Problem 12: Count Vehicles by make and order them by NumberOfVehicles from high to low.
SELECT       Makes.Make, COUNT(*) as NumberOfVehicles
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make
order by NumberOfVehicles desc;


-- Problem 13: Get all Makes/Count Of Vehicles that manufactures more than 20K Vehicles
SELECT       Makes.Make, COUNT(*) as NumberOfVehicles
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make
having COUNT(*) > 20000
order by NumberOfVehicles desc;


-- Problem 14: Get all Makes with make starts with 'B'
select Makes.Make from Makes
where Makes.Make like 'B%';


-- Problem 15: Get all Makes with make ends with 'W'
select Makes.Make from Makes
where Makes.Make like '%W';


-- Problem 16: Get all Makes that manufactures DriveTypeName = FWD
SELECT       distinct Makes.Make, DriveTypes.DriveTypeName
FROM            Makes INNER JOIN
                         VehicleDetails ON Makes.MakeID = VehicleDetails.MakeID INNER JOIN
                         DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
where DriveTypes.DriveTypeName = N'FWD';


-- Problem 17: Get total Makes that Mantufactures DriveTypeName=FWD
select COUNT(*) as TotalMakesWithFWD from
(
	SELECT       distinct Makes.Make, DriveTypes.DriveTypeName
	FROM            Makes INNER JOIN
							 VehicleDetails ON Makes.MakeID = VehicleDetails.MakeID INNER JOIN
							 DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID
	where DriveTypes.DriveTypeName = N'FWD'
) newTable;


-- Problem 18: Get total vehicles per DriveTypeName Per Make and order them per make asc then per total Desc
SELECT       distinct Makes.Make, DriveTypes.DriveTypeName, COUNT(*) as Total
FROM            VehicleDetails INNER JOIN
                         DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make, DriveTypes.DriveTypeName
order by make asc, Total desc;


-- Problem 19: Get total vehicles per DriveTypeName Per Make then filter only results with total > 10,000
SELECT       distinct Makes.Make, DriveTypes.DriveTypeName, COUNT(*) as Total
FROM            VehicleDetails INNER JOIN
                         DriveTypes ON VehicleDetails.DriveTypeID = DriveTypes.DriveTypeID INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make, DriveTypes.DriveTypeName
having COUNT(*) > 10000
order by make asc, Total desc;


-- Problem 20: Get all Vehicles that number of doors is not specified
select * from VehicleDetails
where NumDoors is null;


-- Problem 21: Get Total Vehicles that number of doors is not specified
select COUNT(*) as TotalVehiclesWithoutDoors from VehicleDetails
where NumDoors is null;


-- Problem 22: Get percentage of vehicles that has no doors specified
select 
(
	cast((select COUNT(*) as TotalVehiclesWithoutDoors from VehicleDetails where NumDoors is null) as float) / cast((select COUNT(*) as TotalVechicles from VehicleDetails) as float)
) as Per;


-- Problem 23: Get MakeID , Make, SubModelName for all vehicles that have SubModelName 'Elite'
SELECT       VehicleDetails.MakeID, Makes.Make, SubModels.SubModelName
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID INNER JOIN
                         SubModels ON VehicleDetails.SubModelID = SubModels.SubModelID
WHERE		SubModels.SubModelName = N'Elite';


-- Problem 24: Get all vehicles that have Engines > 3 Liters and have only 2 doors
select * from VehicleDetails
where Engine_Liter_Display > 3 and NumDoors = 2;


-- Problem 25: Get make and vehicles that the engine contains 'OHV' and have Cylinders = 4
SELECT       Makes.Make, VehicleDetails.*
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE		Engine like '%OHV%' and Engine_Cylinders = 4;


-- Problem 26: Get all vehicles that their body is 'Sport Utility' and Year > 2020
SELECT       Bodies.BodyName, VehicleDetails.*
FROM            VehicleDetails INNER JOIN
                         Bodies ON VehicleDetails.BodyID = Bodies.BodyID
WHERE		Bodies.BodyName = N'Sport Utility' and VehicleDetails.Year > 2020;


-- Problem 27: Get all vehicles that their Body is 'Coupe' or 'Hatchback' or 'Sedan'
SELECT       Bodies.BodyName, VehicleDetails.*
FROM            VehicleDetails INNER JOIN
                         Bodies ON VehicleDetails.BodyID = Bodies.BodyID
WHERE		 Bodies.BodyName in ('Coupe', 'Hatchback', 'Sedan');


-- Problem 28: Get all vehicles that their body is 'Coupe' or 'Hatchback' or 'Sedan' and manufactured in year 2008 or 2020 or 2021
SELECT       Bodies.BodyName, VehicleDetails.*
FROM            VehicleDetails INNER JOIN
                         Bodies ON VehicleDetails.BodyID = Bodies.BodyID
WHERE		 Bodies.BodyName in ('Coupe', 'Hatchback', 'Sedan') and VehicleDetails.Year in (2008, 2020, 2021);


-- Problem 29: Return found=1 if there is any vehicle made in year 1950
select found = 1
where exists (select top 1 * from VehicleDetails where year = 1980);


-- Problem 30: Get all Vehicle_Display_Name, NumDoors and add extra column to describe number of doors by words, and if door is null display 'Not Set'
select Vehicle_Display_Name, NumDoors,
case
	when NumDoors = 0 then 'zero doors'
	when NumDoors = 1 then 'one doors'
	when NumDoors = 2 then 'two doors'
	when NumDoors = 3 then 'three doors'
	when NumDoors = 4 then 'four doors'
	when NumDoors = 5 then 'five doors'
	when NumDoors = 6 then 'six doors'
	when NumDoors = 8 then 'eight doors'
	when NumDoors is null then 'not set'
	else 'unknown'
end as DoorDescription
from VehicleDetails;


-- Problem 31: Get all Vehicle_Display_Name, year and add extra column to calculate the age of the car then sort the results by age desc.
select Vehicle_Display_Name, Year, Age = YEAR(GetDate()) - Year from VehicleDetails
order by age desc;


-- Problem 32: Get all Vehicle_Display_Name, year, Age for vehicles that their age between 15 and 25 years old
select * from 
(
	select Vehicle_Display_Name, Year, Age = YEAR(GetDate()) - Year from VehicleDetails
) newTable
where age between 15 and 25;


-- Problem 33: Get Minimum Engine CC , Maximum Engine CC , and Average Engine CC of all Vehicles
select * from VehicleDetails;
select MIN(Engine_CC) as MinCC, AVG(Engine_CC) as AvgCC, MAX(Engine_CC) as MaxCC from VehicleDetails;


-- Problem 34: Get all vehicles that have the minimum Engine_CC
select * from VehicleDetails
where Engine_CC = (select MIN(Engine_CC) from VehicleDetails);


-- Problem 35: Get all vehicles that have the Maximum Engine_CC
select * from VehicleDetails
where Engine_CC = (select MAX(Engine_CC) from VehicleDetails);


-- Problem 36: Get all vehicles that have Engin_CC below average
select * from VehicleDetails
where Engine_CC < (select AVG(Engine_CC) from VehicleDetails);


-- Problem 37: Get total vehicles that have Engin_CC above average
select COUNT(*) as TotalVehiclesAboveTheCCAvg from VehicleDetails
where Engine_CC > (select AVG(Engine_CC) from VehicleDetails);


-- Problem 38: Get all unique Engin_CC and sort them Desc
select distinct Engine_CC from VehicleDetails
order by Engine_CC desc;


-- Problem 39: Get the maximum 3 Engine CC
select distinct top 3 Engine_CC from VehicleDetails
order by Engine_CC desc;


-- Problem 40: Get all vehicles that has one of the Max 3 Engine CC
select * from VehicleDetails
where Engine_CC in 
(
	select distinct top 3 Engine_CC from VehicleDetails
	order by Engine_CC desc
);


-- Problem 41: Get all Makes that manufactures one of the Max 3 Engine CC
SELECT       Makes.Make, VehicleDetails.Engine_CC
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
WHERE		 Engine_CC in 
			(
				select distinct top 3 Engine_CC from VehicleDetails
				order by Engine_CC desc
			)
ORDER BY make;


-- Problem 42: Get a table of unique Engine_CC and calculate tax per Engine CC
select Engine_CC,
case
	when Engine_CC between 0 and 1000 then 100
	when Engine_CC between 1001 and 2000 then 200
	when Engine_CC between 2001 and 4000 then 300
	when Engine_CC between 4001 and 6000 then 400
	when Engine_CC between 6001 and 8000 then 500
	when Engine_CC > 8000 then 600
	else 0
end Tax
from (select distinct Engine_CC from VehicleDetails) newTable
order by Engine_CC;


-- Problem 43: Get Make and Total Number Of Doors Manufactured Per Make
SELECT       Makes.Make, SUM(NumDoors) as TotalDoors
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make;


-- Problem 44: Get Total Number Of Doors Manufactured by 'Ford'
SELECT       Makes.Make, SUM(NumDoors) as TotalDoors
FROM            VehicleDetails INNER JOIN
                         Makes ON VehicleDetails.MakeID = Makes.MakeID
group by Makes.Make
having Makes.Make = 'Ford';


-- Problem 45: Get Number of Models Per Make
SELECT       Makes.Make, COUNT(*) as NumberOfModels
FROM            Makes INNER JOIN
                         MakeModels ON Makes.MakeID = MakeModels.MakeID
group by Makes.Make
order by NumberOfModels desc;


-- Problem 46: Get the highest 3 manufacturers that make the highest number of models
SELECT       top 3 Makes.Make, COUNT(*) as NumberOfModels
FROM            Makes INNER JOIN
                         MakeModels ON Makes.MakeID = MakeModels.MakeID
group by Makes.Make
order by NumberOfModels desc;


-- Problem 47: Get the highest number of models manufactured
select MAX(NumberOfModels) as HighestNumberOfModels from
(
	SELECT       Makes.Make, COUNT(*) as NumberOfModels
	FROM            Makes INNER JOIN
							MakeModels ON Makes.MakeID = MakeModels.MakeID
	group by Makes.Make
) newTable;


-- Problem 48: Get the highest Manufacturers manufactured the highest number of models
SELECT       Makes.Make, COUNT(*) as NumberOfModels
FROM            Makes INNER JOIN
						MakeModels ON Makes.MakeID = MakeModels.MakeID
group by Makes.Make
having COUNT(*) =
(
	select MAX(NumberOfModels) as HighestNumberOfModels from
	(
		SELECT       Makes.Make, COUNT(*) as NumberOfModels
		FROM            Makes INNER JOIN
								MakeModels ON Makes.MakeID = MakeModels.MakeID
		group by Makes.Make
	) newTable
);


-- Problem 49: Get the Lowest Manufacturers manufactured the lowest number of models
SELECT       Makes.Make, COUNT(*) as NumberOfModels
FROM            Makes INNER JOIN
						MakeModels ON Makes.MakeID = MakeModels.MakeID
group by Makes.Make
having COUNT(*) = 
(
	select MIN(NumberOfModels) as LowestNumberOfModels from
	(
		SELECT       Makes.Make, COUNT(*) as NumberOfModels
		FROM            Makes INNER JOIN
								MakeModels ON Makes.MakeID = MakeModels.MakeID
		group by Makes.Make
	) newTable
);


-- Problem 50: Get all Fuel Types , each time the result should be showed in random order
select * from FuelTypes
order by NewID(); -- =The NewID() function will generate GUID for each row
