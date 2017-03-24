"Show the name and address of the keeper of vehicle SO 02 PSP."
Select name,address
From keeper
Join vehicle on keeper.id=vehicle.keeper
Where vehicle.id ="SO 02 PSP"


"Show the number of cameras that take images for incoming vehicles."
Select image.camera
From permit
Join image on permit.reg=image.reg
where permit.sDate>image.whn


"List the image details taken by Camera 10 before 26 Feb 2007."
Select *
From image
Where whn <DATE("2007-02-26") AND camera=10


"List the number of images taken by each camera. 
Your answer should show how many images have been taken by camera 1, camera 2 etc. 
The list must NOT include the images taken by camera 15, 16, 17, 18 and 19."
Select camera,count(*)
From image
where camera not in(15, 16, 17, 18, 19)
Group by camera


"A number of vehicles have permits that start on 30th Jan 2007. 
List the name and address for each keeper in alphabetical order without duplication."
Select distinct name, address
From keeper
Join vehicle on keeper.id=vehicle.keeper
Join permit on permit.reg=vehicle.id and Date(permit.sDate)="2007-01-30"


"List the owners (name and address) of Vehicles caught by camera 1 or 18 without duplication."
Select distinct name,address
From keeper k
Join vehicle v on v.keeper=k.id
Join image i on i.reg=v.id and i.camera in (1,18)

"Show keepers (name and address) who have more than 5 vehicles."
Select name,address
From keeper where keeper.id in (Select keeper
                                From vehicle
                                Group by keeper
                                Having count(distinct id)>=5)


"For each vehicle show the number of current permits (suppose today is the 1st of Feb 2007).
 The list should include the vehicle.s registration and the number of permits. 
 Current permits can be determined based on charge types,
 e.g. for weekly permit you can use the date after 24 Jan 2007 and before 02 Feb 2007"								
Select tmp.reg,sum(tmp.c)
From (Select reg, count(*) as c
	  From permit
	  Where sDate<"2007-02-02" and sDate>"2007-01-24" and chargeType="Weekly"
	  Group by reg
	  Union All
	  Select reg, count(*) as c
	  From permit
	  Where sDate="2007-02-01" and chargeType="Daily"
	  Group by reg
	  Union ALL
	  Select reg, count(*) as c
	  From permit
	  Where sDate<"2007-02-02" and sDate>="2007-02-01" and chargeType="Monthly"
	  Group by reg
	  Union ALL
	  Select reg, count(*) as c
	  From permit
	  Where sDate<"2007-02-02" and sDate>"2006-02-01" and chargeType="Annual"
	  Group by reg) tmp
Group by tmp.reg


"Obtain a list of every vehicle passing camera 10 on 25th Feb 2007. 
Show the time, the registration and the name of the keeper if available."
Select i.whn,i.reg,tmp.name
From image i
Left Join (Select name,vehicle.id as id
           From keeper,vehicle
		   Where keeper.id=vehicle.keeper) tmp 
on tmp.id=i.reg and i.camera=10 and i.whn="2007-02-25"


"List the keepers who have more than 4 vehicles and one of them must have more than 2 permits.
 The list should include the names and the number of vehicles."
Select distinct keeper.name,tmp1.co
From (Select reg
	  From permit 
	  Group by reg
	  Having count(reg)>=2)tmp2,
	(Select v.keeper as keeper,v.id as id,tmp.c as co
	 From vehicle v
	 Join (Select keeper,count(distinct vehicle.id) as c
		   From vehicle
		   Group by keeper
		   Having count(distinct vehicle.id)>=4) tmp on tmp.keeper=v.keeper) tmp1,keeper	    				  
Where tmp2.reg=tmp1.id and keeper.id =tmp1.keeper


"There are four types of permit. 
The most popular type means that this type has been issued the highest number of times. 
Find out the most popular type, together with the total number of permits issued."
Select tmp1.chargeType,tmp1.c1
From (Select chargeType,count(*)as c1
      From permit
      Group by chargeType) tmp1
Where tmp1.c1>= all (Select count(*)
					From permit
					Group by chargeType)

"For each of the vehicles caught by camera 19 - 
show the registration, the earliest time at camera 19 and the time and camera 
at which it left the zone"	  
SELECT image.reg,tmp.ear,tmp.le,image.whn,image.camera
From image
Join (Select reg,min(whn)as ear,max(whn) as le
	  From image
	  Where camera=19
	  Group by reg) tmp on tmp.reg=image.reg and image.whn > tmp.le


"For all 19 cameras-show the position as IN, OUT or INTERNAL and the busiest hour for that camera."
Select camera.id,tmp3.H,camera.perim
From (Select tmp1.camera as ca ,max(tmp1.c) as times
	  From (Select camera,EXTRACT(HOUR FROM whn) AS H,count(*) as c
			From image
			Group by camera,H) tmp1
		    Group by tmp1.camera) tmp2,
	(Select camera,EXTRACT(HOUR FROM whn) AS H,count(*) as c
			From image
			Group by camera,H) tmp3,camera
Where tmp2.ca=tmp3.camera and camera.id=tmp2.ca and tmp2.times=tmp3.c






