--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From public."NashvilleHousing"
--Where PropertyAddress is null
order by "ParcelID";


ALTER TABLE public."NashvilleHousing"
Add NewPropertyAddress varchar;

with t as (
Select a."ParcelID", a."PropertyAddress", b."ParcelID", b."PropertyAddress", Coalesce(a."PropertyAddress",b."PropertyAddress") as newAddress
From public."NashvilleHousing" a
Join public."NashvilleHousing" b
	on a."ParcelID" = b."ParcelID"
	AND a."UniqueID" <> b."UniqueID"
Where a."PropertyAddress" is null
)
Update public."NashvilleHousing"
SET NewPropertyAddress
=  t.newAddress
from t;

alter table public."NashvilleHousing"
drop column NewPropertyAddress

Select a."ParcelID", a."PropertyAddress", b."ParcelID", b."PropertyAddress", Coalesce(a."PropertyAddress",b."PropertyAddress")
From public."NashvilleHousing" a
Join public."NashvilleHousing" b
	on a."ParcelID" = b."ParcelID"
	AND a."UniqueID" <> b."UniqueID"
Where a."PropertyAddress" is null


Update public."NashvilleHousing" as a 
Join public."NashvilleHousing" as b
on a."ParcelID" = b."ParcelID"
	AND a."UniqueID" <> b."UniqueID"
SET "PropertyAddress" = b."PropertyAddress"
Where a."PropertyAddress" is null



Update public."NashvilleHousing"
SET "PropertyAddress" = b."PropertyAddress"
From public."NashvilleHousing"  a
JOIN public."NashvilleHousing"  b
	on a."ParcelID" = b."ParcelID"
	AND a."UniqueID" <> b."UniqueID"
Where a."PropertyAddress" is null


with t as (
Select a."ParcelID", a."PropertyAddress", b."ParcelID", b."PropertyAddress", Coalesce(a."PropertyAddress",b."PropertyAddress") as newAddress
From public."NashvilleHousing" a
Join public."NashvilleHousing" b
	on a."ParcelID" = b."ParcelID"
	AND a."UniqueID" <> b."UniqueID"
Where a."PropertyAddress" is null
)
select * from t;
update public."NashvilleHousing"
SET "PropertyAddress" = t.newAddress
from t;

with t as (
Select a."ParcelID", a."PropertyAddress", b."ParcelID", b."PropertyAddress", Coalesce(a."PropertyAddress",b."PropertyAddress") as newAddress
From public."NashvilleHousing" a
Join public."NashvilleHousing" b
	on a."ParcelID" = b."ParcelID"
	AND a."UniqueID" <> b."UniqueID"
Where a."PropertyAddress" is null
)




--------------------------------------------------------------------------------------------------------------------------


----- separate city and address into different columns
select 
-- substring( "PropertyAddress", 1, position(',' in "PropertyAddress")-1 ) as address,
substring( "PropertyAddress" from 1 for position(',' in "PropertyAddress")-1 ) as address,
 substring( "PropertyAddress" from position(',' in "PropertyAddress")+1 for LENGTH("PropertyAddress") ) as address
-- substring( "PropertyAddress", position(',' in "PropertyAddress")+1, LENGTH("PropertyAddress") ) as address
From public."NashvilleHousing"



ALTER TABLE public."NashvilleHousing"
Add PropertySplitAddress varchar;

Update public."NashvilleHousing"
SET PropertySplitAddress
=substring( "PropertyAddress" from 1 for position(',' in "PropertyAddress")-1 )


ALTER TABLE public."NashvilleHousing"
Add PropertySplitCity varchar;

Update public."NashvilleHousing"
SET PropertySplitCity
=  substring( "PropertyAddress" from position(',' in "PropertyAddress")+1 for LENGTH("PropertyAddress") )

select * from public."NashvilleHousing"
--------------------------------------------------------------------------------------------------------------------------

-- Split Owner Address into 3 columns: address, city, state 

select "OwnerAddress" from public."NashvilleHousing"
-- get number and street, city, state
select split_part("OwnerAddress", ',', 1),
split_part("OwnerAddress", ',', 2),
split_part("OwnerAddress", ',', 3)
from public."NashvilleHousing"

ALTER TABLE public."NashvilleHousing"
Add OwnerSplitAddress varchar;

Update public."NashvilleHousing"
SET OwnerSplitAddress = split_part("OwnerAddress", ',', 1)


ALTER TABLE public."NashvilleHousing"
Add OwnerSplitCity varchar;

Update public."NashvilleHousing"
SET OwnerSplitCity = split_part("OwnerAddress", ',', 2)


ALTER TABLE public."NashvilleHousing"
Add OwnerSplitState varchar;

Update public."NashvilleHousing"
SET OwnerSplitState = split_part("OwnerAddress", ',', 3)

select * from public."NashvilleHousing"

--------------------------------------------------------------------------------------------------------------------------

select distinct("SoldAsVacant"), count("SoldAsVacant")
from public."NashvilleHousing"
group by "SoldAsVacant"

select "SoldAsVacant",
CASE when "SoldAsVacant" = True THEN 'Yes'
	when "SoldAsVacant" = False THEN 'No'
	END
from public."NashvilleHousing"


Update "NashvilleHousing"
SET "SoldAsVacant" = CASE WHEN "SoldAsVacant" = True THEN yes
	 WHEN "SoldAsVacant" = False THEN no
END


--------------------------------------------------------------------------------------------------------------------------
-- Delete unused columns
select * from public."NashvilleHousing"

ALTER TABLE public."NashvilleHousing"
DROP COLUMN "OwnerAddress" , 
DROP COLUMN "PropertyAddress",
DROP COLUMN "TaxDistrict"



select "OwnerName" , count("OwnerName")
from public."NashvilleHousing"
where "OwnerName" is not null
group by "OwnerName"

--------------------------------------------------------------------------------------------------------------------------


select *,
	ROW_NUMBER() OVER(
	PARTITION BY "ParcelID",
				"PropertyAddress",
				"SalePrice",
				"SaleDate",
				"LegalReference"
			Order BY
				"UniqueID"
	) row_num
from public."NashvilleHousing"


