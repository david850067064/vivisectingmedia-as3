/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is ActionScript 3 EventBrokerTests version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests.tests
{
	import com.vivisectingmedia.framework.utils.EventBroker;
	
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	/**
	 * The EventBrokerTests is a Suite of tests designed to validate the functionality of the EventBroker.
	 * This battery of tests should be run before any new checkin is submitted. 
	 * 
	 * @author James Polanco
	 * 
	 */
	public class EventBrokerTests extends TestCase
	{
		protected const BASIC_EVENT_TYPE:String = "BASIC_EVENT_TYPE"
		
		/**
		 * Static method that creates the default suite of tests.
		 *  
		 * @return The active suite for the EventBrokerTests.
		 * 
		 */
		public static function suite():TestSuite
		{
			var ts:TestSuite = new TestSuite();
			
			ts.addTest(new EventBrokerTests("testSubscribeBroadcast"));
			
			return ts;
		}
		
		/**
		 * Constructor.
		 *  
		 * @param methodName Name of the method to run for the test.
		 * 
		 */
		public function EventBrokerTests(methodName:String=null)
		{
			super(methodName);
		}
		
		/**
		 * Verify that the basic ability to subscribe, broadcast and call is functioning
		 * for the the EventBroker. 
		 * 
		 */
		public function testSubscribeBroadcast():void
		{
			EventBroker.subscribe(BASIC_EVENT_TYPE, subscriberMethod);
			EventBroker.broadcast(new Event(BASIC_EVENT_TYPE));
		}
		
		/* simple method to veriy that the event was broadcasted */
		private function subscriberMethod(event:Event):void
		{
			assertTrue("Expecting event.type set to BASIC_EVENT_TYPE.",event.type == BASIC_EVENT_TYPE);
		}
		
	}
}