
SELECT * FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY [UniqueID ];

--Standardize date format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY [UniqueID ];

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE NashvilleHousing
ADD ConvertedSalesDate Date;

UPDATE NashvilleHousing
SET ConvertedSalesDate = CONVERT(Date, SaleDate);

SELECT ConvertedSalesDate, CONVERT(Date, SaleDate)
FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY [UniqueID ];

--Populate property address data

SELECT *
FROM Portfolioproject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolioproject.dbo.NashvilleHousing a
JOIN Portfolioproject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]!= b.[UniqueID ]
WHERE a.PropertyAddress IS NULL ORDER BY a.ParcelID;

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolioproject.dbo.NashvilleHousing a
JOIN Portfolioproject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]!= b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--Breaking out address into individual column address, city and state

SELECT propertyaddress
FROM Portfolioproject.dbo.NashvilleHousing

SELECT 
SUBSTRING(propertyaddress,1,CHARINDEX(',',Propertyaddress)-1) AS Address,
SUBSTRING(propertyaddress,CHARINDEX(',',Propertyaddress)+1,LEN(Propertyaddress)) AS City
FROM Portfolioproject.dbo.NashvilleHousing;


/*SELECT 
CHARINDEX(',',Propertyaddress)
FROM Portfolioproject.dbo.NashvilleHousing;*/

/*SELECT
LEN(Propertyaddress)
FROM Portfolioproject.dbo.NashvilleHousing;*/

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
ADD Propertyaddressnew NVARCHAR(255)


UPDATE Portfolioproject.dbo.NashvilleHousing
SET Propertyaddressnew = SUBSTRING(propertyaddress,1,CHARINDEX(',',Propertyaddress)-1);

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
ADD Propertycity NVARCHAR(255)

UPDATE Portfolioproject.dbo.NashvilleHousing
SET Propertycity = SUBSTRING(propertyaddress,CHARINDEX(',',Propertyaddress)+1,LEN(Propertyaddress))

SELECT *
FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY ParcelID

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY ParcelID

/*SELECT
REPLACE(OwnerAddress,',','.')
FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY ParcelID*/

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
ADD Owneraddressnew NVARCHAR(255);

UPDATE Portfolioproject.dbo.NashvilleHousing
SET Owneraddressnew = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
ADD Ownercity NVARCHAR(255);

UPDATE Portfolioproject.dbo.NashvilleHousing
SET Ownercity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
ADD Ownerstate NVARCHAR(255);

UPDATE Portfolioproject.dbo.NashvilleHousing
SET Ownerstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Changing of Y and N to Yes and No Respectively in the 'SoldAsVacant' Field!

SELECT DISTINCT(SoldAsVacant)
FROM Portfolioproject.dbo.NashvilleHousing

/*SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Portfolioproject.dbo.NashvilleHousing
GROUP BY SoldAsVacant ORDER BY COUNT(SoldAsVacant)*/


SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant ='Y' THEN 'YES'
	WHEN SoldAsVacant ='N' THEN 'NO'
	ELSE SoldAsVacant
	END
FROM Portfolioproject.dbo.NashvilleHousing
WHERE SoldAsVacant = 'N' OR SoldAsVacant = 'Y'

UPDATE Portfolioproject.dbo.NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant ='Y' THEN 'YES'
	WHEN SoldAsVacant ='N' THEN 'NO'
	ELSE SoldAsVacant
	END;

-- Remove Duplicates

WITH row_numCTE AS (
SELECT *,
		ROW_NUMBER() OVER
		(PARTITION BY ParcelId,
						Propertyaddress,
						SalePrice,
						SaleDate,
						LegalReference
						ORDER BY 
						UniqueID
						) row_num
FROM Portfolioproject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
/*SELECT * FROM row_numCTE
WHERE row_num > 1
ORDER BY PropertyAddress*/

DELETE FROM row_numCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
FROM Portfolioproject.dbo.NashvilleHousing
ORDER BY ParcelID;

-- Deleting unwanted columns

ALTER TABLE Portfolioproject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress,SaleDate,OwnerAddress,TaxDistrict;


