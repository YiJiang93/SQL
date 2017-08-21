"Guest 1183. Give the booking_date and the number of nights for guest 1183."
SELECT booking_date,nights
FROM booking
WHERE guest_id=1183

"When do they get here? List the arrival time and the first and last names for all guests due to arrive on 2016-11-05, order the output by time of arrival."
Select arrival_time,first_name,last_name
From booking
Join guest on id= guest_id
Where booking_date= '2016-11-05'
order by arrival_time


"Look up daily rates. Give the daily rate that should be paid for bookings with ids 5152, 5165, 5154 and 5295. Include booking id, room type, number of occupants and the amount."
Select booking_id,room_type_requested,occupants,amount
From booking
Join rate on booking.room_type_requested=rate.room_type and rate.occupancy=booking.occupants
Where booking_id in (5152, 5165, 5154, 5295)


"Who’s in 101? Find who is staying in room 101 on 2016-12-03, include first name, last name and address."
Select first_name,last_name,address
From guest
Join booking on booking.guest_id=guest.id
Where booking_date='2016-12-03' and room_no=101

"How many bookings, how many nights? For guests 1185 and 1270 show the number of bookings made and the total number nights. Your output should include the guest id and the total number of bookings and the total number of nights."
Select guest_id, count(booking_id),sum(nights)
From booking
Where guest_id in(1185,1270)
Group by guest_id

"Show the total amount payable by guest Ruth Cadbury for her room bookings. You should JOIN to the rate table using room_type_requested and occupants."
Select sum(nights*amount)
From rate
Join booking on rate.room_type=booking.room_type_requested and rate.occupancy=booking.occupants
Join guest on guest.id=booking.guest_id and guest.first_name='Ruth' and guest.last_name='Cadbury'


"Including Extras. Calculate the total bill for booking 5128 including extras."
Select sum(b.nights*r.amount)+sum(tmp.m)
From booking b, rate r,(Select sum(amount) as m, booking_id
                        From extra
                        Group by booking_id) tmp
Where b.room_type_requested=room_type and b.occupants=r.occupancy and tmp.booking_id=b.booking_id and b.booking_id=5128


"For every guest who has the word “Edinburgh” in their address show the total number of nights booked. Be sure to include 0 for those guests who have never had a booking. Show last name, first name, address and number of nights. Order by last name then first name."
Select tmp.first_name,tmp.last_name,tmp.address, COALESCE(sum(booking.nights),0)
From booking
Right Join (Select id, first_name,last_name,address
			From guest
			Where address like '%Edinburgh%')tmp on tmp.id=booking.guest_id
Group by tmp.first_name,tmp.last_name,tmp.address
Order by tmp.last_name,tmp.first_name


"Show the number of people arriving. For each day of the week beginning 2016-11-25 show the number of people who are arriving that day"
Select booking_date,count(guest_id)
From booking
Where booking_date between '2016-11-25' and '2016-12-01'
Group by booking_date


"How many guests? Show the number of guests in the hotel on the night of 2016-11-21. Include all those who checked in that day or before but not those who have check out on that day or before."
Select sum(occupants)
From booking
Where booking_date <='2016-11-21' and To_DAYS('2016-11-21')-To_DAYS(booking_date)<nights


"Coincidence. Have two guests with the same surname ever stayed in the hotel on the evening? Show the last name and both first names. Do not include duplicates."
Select distinct tmp1.last_name, tmp1.first_name,tmp2.first_name
From (Select first_name,last_name,booking_date as s1,DATE_ADD(booking_date, INTERVAL nights Day) as c1
      From booking
      Join guest on guest.id=booking.guest_id)tmp1,
	 (Select first_name,last_name,booking_date as s2,DATE_ADD(booking_date, INTERVAL nights Day) as c2
	  From booking
	  Join guest on guest.id=booking.guest_id)tmp2
Where tmp1.last_name=tmp2.last_name and tmp1.first_name<tmp2.first_name and ((tmp1.s1<tmp2.c2 and tmp2.s2<tmp1.c1) or (tmp2.s2<tmp1.c1 and tmp2.c2>tmp1.s1))

"Who is in 207? Who is in room 207 during the week beginning 21st Nov. Be sure to list those days when the room is empty. Show the date and the last name."
Select c.i,tt.last_name
From calendar c left join (Select i,last_name
						From calendar, (Select booking_date,(booking_date + interval nights day) as outday,last_name
										From booking Join guest on guest.id=booking.guest_id
										Where booking.booking_date + interval nights day > '2016-11-21' and booking.booking_date<=('2016-11-21'+ interval 6 day) and room_no=207) t
						Where calendar.i>=t.booking_date and calendar.i<t.outday) tt on tt.i=c.i
Where c.i between '2016-11-21' and ('2016-11-21'+ interval 6 day)
