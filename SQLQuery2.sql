
--Cleaning Data in SQL Queries

Select * From Projectdatabase.dbo.sqldatacleaningproject


-- Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate) From Projectdatabase.dbo.sqldatacleaningproject

ALTER TABLE sqldatacleaningproject
Add SaleDateConverted Date;

Update sqldatacleaningproject
SET SaleDateConverted = CONVERT(Date,SaleDate)
Select SaleDateConverted From Projectdatabase.dbo.sqldatacleaningproject


-- Populate Property Address data
Select * From Projectdatabase.dbo.sqldatacleaningproject
Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Projectdatabase.dbo.sqldatacleaningproject a
JOIN Projectdatabase.dbo.sqldatacleaningproject b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.propertyaddress, b.propertyaddress)
From Projectdatabase.dbo.sqldatacleaningproject a
JOIN Projectdatabase.dbo.sqldatacleaningproject b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress
From Projectdatabase.dbo.sqldatacleaningproject
Where PropertyAddress is null
order by ParcelID

-- Breaking out Address into Individual Columns (Address, City, State)
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Projectdatabase.dbo.sqldatacleaningproject


ALTER TABLE Projectdatabase.dbo.sqldatacleaningproject
Add PropertySplitAddress Nvarchar(255);

Update Projectdatabase.dbo.sqldatacleaningproject
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Projectdatabase.dbo.sqldatacleaningproject
Add PropertySplitCity Nvarchar(255);

Update Projectdatabase.dbo.sqldatacleaningproject
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from Projectdatabase.dbo.sqldatacleaningproject



Select OwnerAddress
From Projectdatabase.dbo.sqldatacleaningproject

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Projectdatabase.dbo.sqldatacleaningproject



ALTER TABLE Projectdatabase.dbo.sqldatacleaningproject
Add OwnerSplitAddress Nvarchar(255);

Update Projectdatabase.dbo.sqldatacleaningproject
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Projectdatabase.dbo.sqldatacleaningproject
Add OwnerSplitCity Nvarchar(255);

Update Projectdatabase.dbo.sqldatacleaningproject
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Projectdatabase.dbo.sqldatacleaningproject
Add OwnerSplitState Nvarchar(255);

Update Projectdatabase.dbo.sqldatacleaningproject
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Projectdatabase.dbo.sqldatacleaningproject

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Projectdatabase.dbo.sqldatacleaningproject
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Projectdatabase.dbo.sqldatacleaningproject


Update Projectdatabase.dbo.sqldatacleaningproject
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- Delete Unused Columns
Select *
From Projectdatabase.dbo.sqldatacleaningproject


ALTER TABLE Projectdatabase.dbo.sqldatacleaningproject
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

