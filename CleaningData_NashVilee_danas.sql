Select *
From PortofolioProject..NashvillHousing

--Standardize Date Format

--THIS IS NOT WORKING
--Update NashvillHousing 
--Set SaleDate = CONVERT(Date, SaleDate)
--INSTEAD TRY THIS

ALTER TABLE NashvillHousing
Add SaleDateConverted Date

Update PortofolioProject..NashvillHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
From PortofolioProject..NashvillHousing

Select *
From PortofolioProject..NashvillHousing
Where PropertyAddress is not null

Select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortofolioProject..NashvillHousing a
JOIN PortofolioProject..NashvillHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortofolioProject..NashvillHousing a
JOIN PortofolioProject..NashvillHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Select PropertyAddress
From PortofolioProject..NashvillHousing



Select
SUBSTRING(PropertyAddress, 1, (CHARINDEX(',',PropertyAddress)-1)) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress)) As address_2
From PortofolioProject..NashvillHousing

ALTER TABLE PortofolioProject..NashvillHousing
Add ProperySplitAddress Nvarchar(255)

Update PortofolioProject..NashvillHousing
Set ProperySplitAddress = SUBSTRING(PropertyAddress, 1, (CHARINDEX(',',PropertyAddress)-1))

ALTER TABLE PortofolioProject..NashvillHousing
Add ProperySplitCity Nvarchar(255)

Update PortofolioProject..NashvillHousing
Set ProperySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT OwnerAddress FROM PortofolioProject..NashvillHousing
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3 ) as OwnerAddress2,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2 ) as OwnerCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1 ) as OwnerState
FROM PortofolioProject..NashvillHousing

ALTER TABLE PortofolioProject..NashvillHousing
Add OwnerAddress2 Nvarchar(255)

Update PortofolioProject..NashvillHousing
Set OwnerAddress2 = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3 ) 

ALTER TABLE PortofolioProject..NashvillHousing
Add OwnerCity Nvarchar(255)

Update PortofolioProject..NashvillHousing
Set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2 )

ALTER TABLE PortofolioProject..NashvillHousing
Add OwnerState Nvarchar(255)

Update PortofolioProject..NashvillHousing
Set OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1 )

SELECT * 
FROM PortofolioProject..NashvillHousing

--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortofolioProject..NashvillHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant, 
		CASE	
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
From PortofolioProject..NashvillHousing

ALTER TABLE PortofolioProject..NashvillHousing
DROP COLUMN SoldAsVacant2

Update PortofolioProject..NashvillHousing
Set SoldAsVacant = 
		CASE	
		WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END

--Remove Duplicates

SELECT *
FROM PortofolioProject..NashvillHousing

Select *,
	ROW_NUMBER() OVER(
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num
FROM PortofolioProject..NashvillHousing
ORDER BY row_num desc , ParcelID desc

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY
			UniqueID
			) row_num
FROM PortofolioProject..NashvillHousing
)
SELECT *
From RowNumCTE

--Delete Unused Columns
Select *
From PortofolioProject..NashvillHousing

ALTER TABLE PortofolioProject..NashvillHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate

