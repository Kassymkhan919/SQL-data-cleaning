-- Populate Property Address data

Select *
From public."NashvilleHousing"
order by "ParcelID";


--------------------------------------------------------------------------------------------------------------------------

----- separate city and address into different columns

SELECT 
 substring( "PropertyAddress", 1, position(',' in "PropertyAddress")-1 ) as address,
 substring( "PropertyAddress" from position(',' in "PropertyAddress")+1 for LENGTH("PropertyAddress") ) as address
FROM public."NashvilleHousing"



ALTER TABLE public."NashvilleHousing"
ADD PropertySplitAddress varchar;

UPDATE public."NashvilleHousing"
SET PropertySplitAddress = substring( "PropertyAddress" from 1 for position(',' in "PropertyAddress")-1 )


ALTER TABLE public."NashvilleHousing"
ADD PropertySplitCity varchar;

UPDATE public."NashvilleHousing"
SET PropertySplitCity = substring( "PropertyAddress" from position(',' in "PropertyAddress")+1 for LENGTH("PropertyAddress") )

select * from public."NashvilleHousing"

--------------------------------------------------------------------------------------------------------------------------

-- Split Owner Address into 3 columns: address, city, state 

select "OwnerAddress" from public."NashvilleHousing"
select split_part("OwnerAddress", ',', 1),
split_part("OwnerAddress", ',', 2),
split_part("OwnerAddress", ',', 3)
from public."NashvilleHousing"

ALTER TABLE public."NashvilleHousing"
ADD OwnerSplitAddress varchar;

UPDATE public."NashvilleHousing"
SET OwnerSplitAddress = split_part("OwnerAddress", ',', 1)


ALTER TABLE public."NashvilleHousing"
ADD OwnerSplitCity varchar;

Update public."NashvilleHousing"
SET OwnerSplitCity = split_part("OwnerAddress", ',', 2)


ALTER TABLE public."NashvilleHousing"
ADD OwnerSplitState varchar;

UPDATE public."NashvilleHousing"
SET OwnerSplitState = split_part("OwnerAddress", ',', 3)

select * from public."NashvilleHousing"

--------------------------------------------------------------------------------------------------------------------------

-- Change True, False in SoldAsVacant column to Yes, No
SELECT DISTINCT("SoldAsVacant"), COUNT("SoldAsVacant")
FROM public."NashvilleHousing"
GROUP BY "SoldAsVacant"

SELECT "SoldAsVacant",
CASE WHEN "SoldAsVacant" = True THEN 'Yes'
	WHEN "SoldAsVacant" = False THEN 'No'
	END
FROM public."NashvilleHousing"


UPDATE "NashvilleHousing"
SET "SoldAsVacant" = CASE 
	WHEN "SoldAsVacant" = True THEN yes
	 WHEN "SoldAsVacant" = False THEN no
END


--------------------------------------------------------------------------------------------------------------------------
-- Delete unused columns
select * from public."NashvilleHousing"

ALTER TABLE public."NashvilleHousing"
DROP COLUMN "OwnerAddress" , 
DROP COLUMN "PropertyAddress",
DROP COLUMN "TaxDistrict"


