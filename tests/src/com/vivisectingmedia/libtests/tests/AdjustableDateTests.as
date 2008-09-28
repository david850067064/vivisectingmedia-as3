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
package com.vivisectingmedia.libtests.tests
{
	import com.vivisectingmedia.framework.utils.AdjustableDate;
	
	import flexunit.framework.TestCase;

	public class AdjustableDateTests extends TestCase
	{
		public function AdjustableDateTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * This test verifies that the day offset works in both postitive
		 * and negative values as expected. 
		 * 
		 */
		public function testOffsetDays():void
		{
			var baseDate:Date = new Date(2008, 8, 5);
			var adjustDate:AdjustableDate = new AdjustableDate(2008, 8, 5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the date back to the first of the month
			adjustDate.offsetDays(-4);
			assertTrue("The date was not adjusted back four days.", adjustDate.date == 1);
			
			// adjust the date to the 5th
			adjustDate.offsetDays(4);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the date to August 31st
			adjustDate.offsetDays(-5);
			assertTrue("The date was not set to the 31st.", adjustDate.date == 31);
			
			// verify zero does not affect the date
			adjustDate.offsetDays(0);
			assertTrue("The date was changed when it should not have been.", adjustDate.date == 31);
		}
		
		/**
		 * Tests the Months offset functionality, verifying that it spans months
		 * and years correctly. 
		 * 
		 */
		public function testOffsetMonths():void
		{
			var baseDate:Date = new Date(2008, 8, 5);
			var adjustDate:AdjustableDate = new AdjustableDate(2008, 8, 5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the month back to august 8th
			adjustDate.offsetMonths(-1);
			assertTrue("The date was not adjusted back one month.", adjustDate.month == 7);
			assertTrue("The date's day was changed incorrectly.", adjustDate.date == 5);
			
			// adjust the month back to february 8th
			adjustDate.offsetMonths(-6);
			assertTrue("The date was not adjusted back six months.", adjustDate.month == 1);
			assertTrue("The date's day was changed incorrectly for 6 months.", adjustDate.date == 5);
			
			// adjust the month back to start
			adjustDate.offsetMonths(7);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the month across previous year
			adjustDate.offsetMonths(-10);
			assertTrue("The date was not adjusted back 10 months.", adjustDate.month == 10);
			assertTrue("The date's day was changed incorrectly for 10 months.", adjustDate.date == 5);
			assertTrue("The date's year was changed incorrectly for 10 months.", adjustDate.year == 2007);
			
			adjustDate.offsetMonths(10);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the month across the next year
			adjustDate.offsetMonths(12);
			assertTrue("The date was not adjusted back 10 months.", adjustDate.month == 8);
			assertTrue("The date's day was changed incorrectly for 10 months.", adjustDate.date == 5);
			assertTrue("The date's year was changed incorrectly for 10 months.", adjustDate.year == 2009);
			
			adjustDate.offsetMonths(-12);
			assertTrue("Dates are not the same after adjustment.", baseDate.time == adjustDate.time);
			
			// update the dates to a 31st.  verify that it updates the month correctly
			baseDate = new Date(2008, 0, 31);
			adjustDate = new AdjustableDate(2008, 0, 31);
			
			// adjust the month to to february 31st, make sure it becomes the 29th
			adjustDate.offsetMonths(1);
			assertTrue("The date was not adjusted forward 1 mont.", adjustDate.month == 1);
			assertTrue("The date was not adjusted to fit the leap year.", adjustDate.date == 29);
			
			// update the dates to a 31st.  verify that it updates the month correctly
			baseDate = new Date(2008, 2, 31);
			adjustDate = new AdjustableDate(2008, 2, 31);
			
			// adjust the month to to April 31st, make sure it becomes the 30th
			adjustDate.offsetMonths(1);
			assertTrue("The date was not adjusted back forward one month.", adjustDate.month == 3);
			assertTrue("The date was not changed to the 30th.", adjustDate.date == 30);
		}
		
		
		/**
		 * Verify that adjusting the year modifies the date year properly. 
		 * 
		 */
		public function testAdjustYears():void
		{
			var baseDate:Date = new Date(2008, 8, 5);
			var adjustDate:AdjustableDate = new AdjustableDate(2008, 8, 5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
			// adjust the date by 5 years backwards
			adjustDate.offsetYears(-5);
			assertTrue("The date was not adjusted back 5 years.", adjustDate.month == 8);
			assertTrue("The date's day was changed incorrectly for 5 years.", adjustDate.date == 5);
			assertTrue("The date's year was changed incorrectly for 5 years.", adjustDate.year == 2003);
			
			adjustDate.offsetYears(5);
			
			// verify the dates are the same
			assertTrue("Dates are not the same before adjustment.", baseDate.time == adjustDate.time);
			
		}
	}
}