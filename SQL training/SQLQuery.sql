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
