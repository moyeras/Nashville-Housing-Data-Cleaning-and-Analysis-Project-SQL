select * from PortfolioProject.dbo.NashvilleHousing

select SaleDateConverted,Convert(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = Convert(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = Convert(date,SaleDate)


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID and
	a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
	where a.PropertyAddress is null


select PropertySplitAddress,PropertySplitCity
from PortfolioProject.dbo.NashvilleHousing

select 
SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) AS Address
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity  Nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) 


SELECT 
     SUBSTRING(OwnerAddress, 1, CHARINDEX(',', OwnerAddress) - 1) AS Address1,
    
    SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress) + 1, 
        CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) - CHARINDEX(',', OwnerAddress) - 1) AS Address2,
    
    LTRIM(SUBSTRING(OwnerAddress, CHARINDEX(',', OwnerAddress, CHARINDEX(',', OwnerAddress) + 1) + 1, LEN(OwnerAddress))) AS Last_Part
FROM 
    PortfolioProject.dbo.NashvilleHousing;


select parsename(replace(OwnerAddress, ',','.'),3),
parsename(replace(OwnerAddress, ',','.'),2),
parsename(replace(OwnerAddress, ',','.'),1)
from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAdress  Nvarchar(255);


update NashvilleHousing
set OwnerSplitAdress =  parsename(replace(OwnerAddress, ',','.'),3)


alter table NashvilleHousing
add OwnerSplitCity  Nvarchar(255);


update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',','.'),2)


alter table NashvilleHousing
add OwnerCityState  Nvarchar(255);


update NashvilleHousing
set OwnerCityState =   parsename(replace(OwnerAddress, ',','.'),1)




select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant =   case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end




With RowNumCTE as (	
select *,ROW_NUMBER() over (
Partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by 
			UniqueID 
			) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
delete
from RowNumCTE
Where row_num > 1




alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate




select * from PortfolioProject.dbo.NashvilleHousing

