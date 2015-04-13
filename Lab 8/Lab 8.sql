----------------------------------------------------------------------------------------
-- Lab 8
-- Database Management
-- @author Robert Coords
-- 4/9/2015
----------------------------------------------------------------------------------------

-- Drops all tables
drop table if exists purchaseOrders;
drop table if exists clothes;
drop table if exists suppliers;

-- Question 2
-- SQL statements to create tables within database.

-- Clothes --
create table clothes (
	 sku				char(4) not null,
	 description		text,
	 retailPriceUSD		numeric(10,2),
	 quantityOnHand		integer,
	primary key (sku)
);

-- Suppliers --
create table suppliers (
	 name			text not null,
	 address		text,
	 city			text,
	 state			char(2),
	 zipCode		numeric(5,0),
	 phoneNum		numeric(11,0),
	 email			text,
	 paymentTerms	text,
	primary key (name)
);

-- PurchaseOrders --
create table purchaseOrders (
	 purchaseOrderNum		char(5) not null,
	 supplier				text not null references suppliers(name),
	 sku					char(4) not null references clothes(sku),
	 skuQuantity			integer not null,
	 skuPurchasePriceUSD	numeric(10,2) not null,
	 date					date not null,
	 comments				text,
	primary key (purchaseOrderNum)
);

-- Question 3
-- SQL statements to add example data to database.

-- Clothes --
insert into clothes ( sku, description, retailPriceUSD, quantityOnHand )
	values( 's001', 'shirt', 30.00, 300 );
insert into clothes ( sku, description, retailPriceUSD, quantityOnHand )
	values( 's002', 'baseball cap', 15.00, 200 );
insert into clothes ( sku, description, retailPriceUSD, quantityOnHand )
	values( 's005', 'sweater', 35.00, 175 );
insert into clothes ( sku, description, retailPriceUSD, quantityOnHand )
	values( 's007', 'jeans', 40.00, 350 );
insert into clothes ( sku, description, retailPriceUSD, quantityOnHand )
	values( 's008', 'socks', 20.00, 500 );
insert into clothes ( sku, description, retailPriceUSD, quantityOnHand )
	values( 's010', 'rain coat', 23.50, 160 );

-- Suppliers --
insert into suppliers ( name, address, city, state, zipCode, phoneNum, email, paymentTerms )
	values( 'Gap', '3083 Cleveland St', 'Atlanta', 'GA', 30114, 12025550113, 'ProductOrders@GAP.com', 'Cash on delivery' );
insert into suppliers ( name, address, city, state, zipCode, phoneNum, email, paymentTerms )
	values( 'American Eagle Outfitters', '816 Westchester Ave', 'White Plains', 'NY', 10601, 19145550153, 'ProductOrders@AEOutfitters.com', 'Cash next day' );
insert into suppliers ( name, address, city, state, zipCode, phoneNum, email, paymentTerms )
	values( 'Stark Winter Gear', '180 Westeros St', 'Donora', 'PA', 15033, 15128424900, 'ProductOrders@StarkWinterGear.com', 'End of month' );
insert into suppliers ( name, address, city, state, zipCode, phoneNum, email, paymentTerms )
	values( 'Valve Hats International', '212 East Jaden St', 'City 17', 'CA', 90274, 17343897473, 'PurchaseOrders@ValveHats.com', 'Cash with order' );
insert into suppliers ( name, address, city, state, zipCode, phoneNum, email, paymentTerms )
	values( 'Summer Days Clothing and Fabric Co.', '19 Main St', 'Rye', 'NY', 10580, 19149214365, 'PurchaseOrders@SumerDays.com', 'Cash on delivery' );
insert into suppliers ( name, address, city, state, zipCode, phoneNum, email, paymentTerms )
	values( 'Harbor Light Clothing Company', '21 Mountain Drive', 'Stamford', 'CT', 06901, 16017829844, 'PurchaseOrders@HarborLightClothes.com', 'End of month' );

-- PurchaseOrders --
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0012', 'American Eagle Outfitters', 's007', 125, 30.00, '2013-04-12', 'No comments for this order.' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0013', 'Valve Hats International', 's002', 50, 7.50, '2013-12-12', 'N/A' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0016', 'American Eagle Outfitters', 's007', 100, 30.00, '2014-04-10', 'No comments for this order.' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0017', 'Harbor Light Clothing Company', 's001', 150, 20.00, '2014-06-20', 'N/A' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0018', 'Harbor Light Clothing Company', 's005', 200, 25.00, '2014-06-20', 'N/A' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0020', 'Summer Days Clothing and Fabric Co.', 's001', 50, 25.00, '2014-08-04', 'N/A' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0021', 'Gap', 's007', 50, 30.00, '2015-01-15', 'N/A' );
insert into purchaseOrders ( purchaseOrderNum, supplier, sku, skuQuantity, skuPurchasePriceUSD, date, comments )
	values( 'p0023', 'American Eagle Outfitters', 's007', 125, 30.00, '2015-04-06', 'No comments for this order.'  );

-- Question 5
-- Query to calculate how many of a given sku are being sold.

select c.quantityOnHand + orders.orderedSum
from clothes c, (select sku, sum(skuQuantity) as orderedSum
				 from purchaseOrders
				 where sku = 's007' -- change sku value here
				 group by sku) as orders
where c.sku = orders.sku;