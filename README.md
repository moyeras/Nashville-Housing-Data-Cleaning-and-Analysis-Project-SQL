# Nashville Housing Data Cleaning and Analysis Project

## Overview

This project focuses on cleaning and transforming the `NashvilleHousing` dataset to enhance its usability for analysis. The goal is to ensure data integrity by addressing missing values, converting data types, and splitting complex address fields.

## Tables Used

- `PortfolioProject..NashvilleHousing`: Contains data on housing sales in Nashville, including details such as sale dates, property addresses, and owner information.

## Dataset

The dataset consists of various attributes related to Nashville housing, including sale dates, property addresses, and owner addresses. This analysis aims to refine the dataset for better analytical capabilities.
link:github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx

## SQL Queries

### Data Retrieval

1. Retrieve all data from the `NashvilleHousing` table for initial exploration:
    ```sql
    SELECT * FROM PortfolioProject.dbo.NashvilleHousing;
    ```

### Data Type Conversion

2. Convert `SaleDate` to a proper date format:
    ```sql
    UPDATE NashvilleHousing
    SET SaleDate = CONVERT(date, SaleDate);
    ```

3. Add a new column for the converted sale date:
    ```sql
    ALTER TABLE NashvilleHousing
    ADD SaleDateConverted Date;

    UPDATE NashvilleHousing
    SET SaleDateConverted = CONVERT(date, SaleDate);
    ```

### Handling Missing Property Addresses

4. Identify and update missing property addresses using available data:
    ```sql
    UPDATE a
    SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
    FROM PortfolioProject.dbo.NashvilleHousing a
    JOIN PortfolioProject.dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
    AND a.[UniqueID] <> b.[UniqueID]
    WHERE a.PropertyAddress IS NULL;
    ```

### Splitting Property Address

5. Split the property address into street address and city:
    ```sql
    ALTER TABLE NashvilleHousing
    ADD PropertySplitAddress Nvarchar(255),
        PropertySplitCity Nvarchar(255);

    UPDATE NashvilleHousing
    SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
        PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));
    ```

### Splitting Owner Address

6. Split the owner address into components:
    ```sql
    ALTER TABLE NashvilleHousing
    ADD OwnerSplitAddress Nvarchar(255),
        OwnerSplitCity Nvarchar(255),
        OwnerCityState Nvarchar(255);

    UPDATE NashvilleHousing
    SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
        OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
        OwnerCityState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);
    ```

### Handling SoldAsVacant Values

7. Update `SoldAsVacant` values for clarity:
    ```sql
    UPDATE NashvilleHousing
    SET SoldAsVacant = CASE 
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant 
    END;
    ```

### Removing Duplicate Records

8. Remove duplicate records based on unique criteria:
    ```sql
    WITH RowNumCTE AS (	
        SELECT *, ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID 
        ) AS row_num
        FROM PortfolioProject.dbo.NashvilleHousing
    )
    DELETE FROM RowNumCTE
    WHERE row_num > 1;
    ```

### Dropping Unnecessary Columns

9. Remove columns that are no longer needed:
    ```sql
    ALTER TABLE PortfolioProject.dbo.NashvilleHousing
    DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
    ```

### Final Data Check

10. Retrieve the cleaned dataset to verify changes:
    ```sql
    SELECT * FROM PortfolioProject.dbo.NashvilleHousing;
    ```

## Conclusion

This project effectively cleans and transforms the `NashvilleHousing` dataset to enhance its analytical capabilities. By addressing missing values, converting data types, and refining address fields, the dataset is now better suited for analysis and visualization. Future analyses can build on this refined dataset to derive insights about the Nashville housing market.
