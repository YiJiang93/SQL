"Give the room id in which the event co42010.L01 takes place."
Select event.room
From event
Where event.id="co42010.L01"


Select attends.student
From event,attends
Where event.modle in (Select id
                      From modle
                      Where name like "%Database%") and event.id=attends.event 

					  
"Show the 'size' of each of the co72010 events. Size is the total number of students attending each event."
Select event.id, count(attends.student)
From event,attends
Where event.modle="co72010" and event.id=attends.event
Group by event.id



"Identify those events which start at the same time as one of the co72010 lectures."
Select t.id
From
(Select id,tmp.w as ww,dow,tod
From event Join (Select event,min(week) as w
				 From occurs
				 Group by occurs.event) tmp on tmp.event=event.id) t,
(select id,tmp1.w1 as ww1,dow,tod
From event Join (Select event,min(week) as w1
			   From occurs
			   Group by occurs.event) tmp1 on tmp1.event=event.id and event.modle= "co72010") tmp2 
Where tmp2.ww1=t.ww and tmp2.dow=t.dow and tmp2.tod=t.tod and tmp2.id<> t.id



 
"How many members of staff have contact time which is greater than the average?" 
Select fi2.s
From (Select avg(h.t) as a
	From (
	Select sum(all_week*d) as t,staff
	From (Select event, count(week) as all_week
		  From occurs
		  Group by event) tmp1,
		 (SELECT sum(duration) as d,id
		  From event
		  Group by id) tmp2 ,
		 (Select event, staff
		  From teaches
		  Group by event,staff) tmp3
	Where tmp1.event=tmp2.id and tmp1.event=tmp3.event
	Group by tmp3.staff) h) fi1,
	(Select sum(all_week*d) as t,tmp3.staff as s
	From (Select event, count(week) as all_week
		  From occurs
		  Group by event) tmp1,
		 (SELECT sum(duration) as d,id
		  From event
		  Group by id) tmp2 ,
		 (Select event, staff
		  From teaches
		  Group by event,staff) tmp3
	Where tmp1.event=tmp2.id and tmp1.event=tmp3.event
	Group by tmp3.staff) fi2
Where fi2.t>fi1.a



