
"Show the first name and the email address of customer with CompanyName 'Bike World'"
Select FirstName, EmailAddress
From Customer
Where CompanyName ='Bike World'


"Show the CompanyName for all customers with an address in City 'Dallas'."
Select distinct CompanyName 
From Customer c Join CustomerAddress ca ON ca.CustomerID=c.CustomerID
Join Address a on a.AddressID=ca.AddressID
Where a.City="Dallas"

"How many items with ListPrice more than $1000 have been sold?"
Select Sum(OrderQty)
From SalesOrderDetail
Where ProductId in (Select ProductID
                    From Product
                    Where ListPrice >1000)


"Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight."
Select c.CompanyName
From Customer c
Where CustomerID in (Select Customer.CustomerID
					From Customer Join (Select s1.SalesOrderID as o1,CustomerID,(SubTotal+TaxAmt+Freight) as fee
										From SalesOrderHeader s1) tmp On tmp.CustomerID=Customer.CustomerID
					Group by Customer.CustomerID
					Having Sum(tmp.fee)>100000)

"Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'"
Select sum(tmp.q)
From Customer, (SELECT sh.CustomerID,sum(sd.OrderQty) as q
				FROM Product p,SalesOrderDetail sd,SalesOrderHeader sh
				WHERE p.Name= 'Racing Socks, L' and p.ProductID=sd.ProductID and sd.SalesOrderID=sh.SalesOrderID
				Group by sh.CustomerID) tmp
Where tmp.CustomerID=Customer.CustomerID and Customer.CompanyName='Riding Cycles'


"A 'Single Item Order' is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order."
Select SalesOrderID,UnitPrice
From SalesOrderDetail
Where SalesOrderID in (Select SalesOrderID
						From SalesOrderDetail
						Group by SalesOrderID
						Having sum(OrderQty)=1)
						
"Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'."
Select p.Name, c.CompanyName
From Product p Join ProductModel pm On pm.ProductModelID=p.ProductModelID and pm.Name="Racing Socks"
Join SalesOrderDetail sd on p.ProductID=sd.ProductID
Join SalesOrderHeader sh on sh.SalesOrderID=sd.SalesOrderID
Join Customer c on c.CustomerID=sh.CustomerID

"Show the product description for culture 'fr' for product with ProductID 736."
Select pd.Description
From Product p Join ProductModel pm on pm.ProductModelID=p.ProductModelID and p.ProductID=736
Join ProductModelProductDescription pmpd On pmpd.ProductModelID=pm.ProductModelID and pmpd.Culture="fr"
Join ProductDescription pd on pd.ProductDescriptionID=pmpd.ProductDescriptionID


"Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. 
For each order show the CompanyName and the SubTotal and the total weight of the order."
Select c.CompanyName, sh.SubTotal,tmp.w
From Customer c,SalesOrderHeader sh,(Select sd.SalesOrderID as id,sum(OrderQty*Weight) AS w
									From SalesOrderDetail sd, Product p
									Where p.ProductID=sd.ProductID
									Group by sd.SalesOrderID) tmp
Where c.CustomerID=sh.CustomerID and sh.SalesOrderID= tmp.id
Order by sh.SubTotal desc


"How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?"
Select sum(sd.OrderQty)
From Product p Join ProductCategory pc On pc.ProductCategoryID=p.ProductCategoryID and pc.Name='Cranksets'
Join SalesOrderDetail sd on sd.ProductID=p.ProductID
Join SalesOrderHeader sh on sd.SalesOrderID=sh.SalesOrderID
Join Address a On a.AddressID=sh.ShipToAddressID and a.City='London'

"For every customer with a 'Main Office' in Dallas show AddressLine1 of the 'Main Office' 
and AddressLine1 of the 'Shipping' address - 
if there is no shipping address leave it blank. Use one row per customer."
SELECT tmp1.id,tmp1.main,tmp.ship
From ((Select ca.CustomerID as id,a.AddressLine1 as main
		From CustomerAddress ca, Address a 
		Where a.AddressID=ca.AddressID and ca.AddressType= "Main Office" and a.City="Dallas") tmp1
		Left Join (Select CustomerID, Address.AddressLine1 as ship
				   From CustomerAddress, Address
				   Where CustomerID in (Select ca1.CustomerID
									   From CustomerAddress ca1, Address a1 
									   Where a1.AddressID=ca1.AddressID and ca1.AddressType= "Main Office" and a1.City="Dallas")
				   And AddressType="Shipping" and Address.AddressID=CustomerAddress.AddressID) tmp
		On tmp.CustomerID=tmp1.id)















