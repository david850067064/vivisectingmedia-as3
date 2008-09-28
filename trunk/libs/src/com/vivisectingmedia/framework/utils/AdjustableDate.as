/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2008 James Polanco
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * ***** END MIT LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.utils
{
	import mx.effects.easing.Back;
	
	public class AdjustableDate
	{
		/* PRIVATE PROPERTIES */
		// internal date object that AdjustableDate wraps
		private var _date:Date;
		
		/* STATIC METHODS */
		/**
		 * Determines if the provided year is a leap year.
		 *  
		 * @param year The year to verify, should be in 4 digit YYYY format.
		 * @return True if year is a leap year, false if not.
		 * 
		 */		
		static public function isLeapYear(year:Number):Boolean
		{
			return ( 0 == (year % 4) && 0 != (year % 100) || 0 == (year % 400)) ? true : false;
		}
		
		/* CONSTRUCTOR */
		public function AdjustableDate(yearOrTime:Object, month:Number, date:Number=1, hour:Number=0, minute:Number=0, second:Number=0, millisecond:Number=0)
		{
			_date = new Date(yearOrTime, month, date, hour, minute, second, millisecond);
		}

		/* PUBLIC METHODS */
		public function get dateInstance():Date
		{
			return _date;
		}
		/**
		 * The number of milliseconds since midnight January 1, 1970, 
		 * universal time, for a Date object. Use this method to 
		 * represent a specific instant in time when comparing 
		 * two or more AdjustableDate objects.
		 * 
		 * @param value The new time in milliseconds.
		 * 
		 */
		public function set time(value:Number):void
		{
			_date.time = value;
		}
		
		public function get time():Number
		{
			return _date.time;
		}
		
		/**
		 * The day of the month (an integer from 1 to 31) specified by a 
		 * Date object according to local time. Local time is determined 
		 * by the operating system on which Flash Player is running.
		 * 
		 * @param value
		 * 
		 */		
		public function set date(value:Number):void
		{
			_date.date = value;
		}
		
		public function get date():Number
		{
			return _date.date;
		}
		
		/**
		 * The month (0 for January, 1 for February, and so on) portion of 
		 * a Date object according to local time. Local time is determined 
		 * by the operating system on which Flash Player is running. 
		 * 
		 * @param value
		 * 
		 */
		public function set month(value:Number):void
		{
			_date.month = value;
		}
		
		public function get month():Number
		{
			return _date.month;
		}
		
		/**
		 * The full year (a four-digit number, such as 2000) of a Date 
		 * object according to local time. Local time is determined 
		 * by the operating system on which Flash Player is running.
		 * 
		 * @param value
		 * 
		 */
		public function set year(value:Number):void
		{
			_date.fullYear = value;
		}
		
		public function get year():Number
		{
			return _date.fullYear;
		}
		
		/**
		 * The number of seconds since midnight January 1, 1970, 
		 * universal time, for a Date object. Use this method to 
		 * represent a specific instant in time when comparing 
		 * two or more AdjustableDate objects.
		 *  
		 * @return 
		 * 
		 */
		public function get sinceEpoch():Number
		{
			return (_date.time / 1000);
		}
		
		/**
		 * Change the current AdjustableDate's milliseconds value
		 * by passing in a postitive or negative number.
		 * 
		 * <p>For example: To set the current time back 500 milliseconds
		 * you would pass in -500.  To set the current time forward 500
		 * milliseconds you would pass in 500.</p>
		 * 
		 * @param amount The number of milliseconds to change the current time by.
		 * 
		 */
		public function offsetMilliseconds(amount:Number):void
		{
			if(amount == 0) return;
			_date.time += amount;			
		}
		
		/**
		 * Change the current AdjustableDate's seconds value
		 * by passing in a postitive or negative number.
		 * 
		 * <p>For example: To set the current time back 10 seconds
		 * you would pass in -10.  To set the current time forward 10
		 * seconds you would pass in 10.</p>
		 * 
		 * @param amount The number of seconds to change the current time by.
		 * 
		 */
		public function offsetSeconds(amount:int):void
		{
			if(amount == 0) return;
			_date.time += (amount * 1000);	
		}
		
		/**
		 * Change the current AdjustableDate's minutes value
		 * by passing in a postitive or negative number.
		 * 
		 * <p>For example: To set the current time back 20 minutes
		 * you would pass in -20.  To set the current time forward 20
		 * minutes you would pass in 20.</p>
		 * 
		 * @param amount The number of minutes to change the current time by.
		 * 
		 */
		public function offsetMinutes(amount:int):void
		{
			if(amount == 0) return;
			_date.time += (amount * 60000);	
		}
		
		/**
		 * Change the current AdjustableDate's hours value
		 * by passing in a postitive or negative number.
		 * 
		 * <p>For example: To set the current time back 5 hours
		 * you would pass in -5.  To set the current time forward 5
		 * hours you would pass in 5.</p>
		 * 
		 * @param amount The number of hours to change the current time by.
		 * 
		 */
		public function offsetHours(amount:int):void
		{
			if(amount == 0) return;
			_date.time += (amount * 3600000);
		}
		
		/**
		 * Change the current AdjustableDate's days value
		 * by passing in a postitive or negative number.
		 * 
		 * <p>For example: To set the current time back 5 days
		 * you would pass in -5.  To set the current time forward 5
		 * days you would pass in 5.</p>
		 * 
		 * @param amount The number of days to change the current time by.
		 * 
		 */
		public function offsetDays(amount:int):void
		{
			if(amount == 0) return;
			_date.time += (amount * 86400000);
		}
		
		/**
		 * Change the current AdjustableDate's months value
		 * by passing in a postitive or negative number. This method
		 * proplery adjusts the months as they pass over years, leap
		 * years, etc.
		 * 
		 * <p>For example: To set the current time back 5 months
		 * you would pass in -5.  To set the current time forward 5
		 * months you would pass in 5.</p>
		 * 
		 * @param amount The number of months to change the current time by.
		 * 
		 */
		public function offsetMonths(amount:int):void
		{
			// get the number of months
			if(amount == 0) return;
			var count:Number = Math.abs(amount);
			var backward:Boolean = (amount < 0) ? true : false;
			
			var currentMonth:Number = _date.month;
			var currentDay:Number = _date.date;
			var currentYear:Number = _date.fullYear;
			
			// offset the months and the years
			for(var i:uint = 0; i < count; i++)
			{
				// get the new month
				(backward) ? currentMonth-- : currentMonth++;
				
				// offset the years
				if(currentMonth > 11) 
				{
					currentMonth = 0;
					currentYear++;
				} else if(currentMonth < 0)  {
					currentMonth = 11;
					currentYear--;
				}
			}
			
			// verify the day is not beyond 28
			var febDays:Number = AdjustableDate.isLeapYear(currentYear) ? 29 : 28;
			if(currentDay > febDays)
			{
				switch(currentMonth)
				{
					case 1:
						// set it to the current month
						currentDay = febDays;
					break;
					
					case 3:
					case 5:
					case 8:
					case 10:
						// set it less the 31
						currentDay = (currentDay > 30) ? 30 : currentDay;
					break;
				}
			}
			
			// update the date
			_date.date = currentDay;
			_date.month = currentMonth;
			_date.fullYear = currentYear;
		}
		
		/**
		 * Change the current AdjustableDate's years value
		 * by passing in a postitive or negative number.
		 * 
		 * <p>For example: To set the current time back 5 years
		 * you would pass in -5.  To set the current time forward 5
		 * years you would pass in 5.</p>
		 * 
		 * @param amount The number of years to change the current time by.
		 * 
		 */
		public function offsetYears(amount:int):void
		{
			if(amount == 0) return;
			_date.fullYear = _date.fullYear + amount;
		}

	}
}