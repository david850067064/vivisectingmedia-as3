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
 * The Original Code is ActionScript 3 EventSubscriber version 1.0.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by James Polanco are Copyright (C) 2008
 * James Polanco. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.libtests.elements
{
	import com.vivisectingmedia.framework.utils.EventBroker;
	import com.vivisectingmedia.libtests.tests.EventBrokerTests;
	
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	/**
	 * This class is a helper class for testing the EventBroker. This class provides
	 * an API to enable subscribing the object to the Events and verifying both
	 * Event type and the number of times called.
	 *  
	 * @author James Polanco
	 * 
	 */
	public class EventSubscriber
	{
		/* stores the number of calls made to the methods */
		private var __callCount:int = 0;
		
		/**
		 * Constructor 
		 * 
		 */
		public function EventSubscriber()
		{
		}
		
		/**
		 * The number of times the subscribed methods have been called. 
		 * @return 
		 * 
		 */
		public function get callCount():int
		{
			return __callCount;
		}
		
		/**
		 * This method subscribes the object to the BASIC_EVENT_TYPE and
		 * is bound to callMethodOne().
		 * 
		 */
		public function subscribeMethodOne():void
		{
			EventBroker.subscribe(EventBrokerTests.BASIC_EVENT_TYPE, callMethodOne);
		}
		
		/**
		 * This method subscribes the object to the BASIC_EVENT_TYPE and
		 * is bound to callMethodTwo().
		 * 
		 */
		public function subscribeMethodTwo():void
		{
			EventBroker.subscribe(EventBrokerTests.BASIC_EVENT_TYPE, callMethodTwo);
		}
		
		/**
		 * This method subscribes the object to the SECOND_EVENT_TYPE and
		 * is bound to callMethodThree().
		 * 
		 */
		public function subscribeMethodThree():void
		{
			EventBroker.subscribe(EventBrokerTests.SECOND_EVENT_TYPE, callMethodThree);
		}
		
		/**
		 * Method closure called by EventBroker.
		 * @param event Asserts against BASIC_EVENT_TYPE
		 * 
		 */
		public function callMethodOne(event:Event):void
		{
			Assert.assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE)
			__callCount++;
		}
		
		/**
		 * Method closure called by EventBroker.
		 * @param event Asserts against BASIC_EVENT_TYPE
		 * 
		 */
		public function callMethodTwo(event:Event):void
		{
			Assert.assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.BASIC_EVENT_TYPE)
			__callCount++;
		}
		
		/**
		 * Method closure called by EventBroker.
		 * @param event Asserts against SECOND_EVENT_TYPE
		 * 
		 */
		public function callMethodThree(event:Event):void
		{
			Assert.assertTrue("Broadcasted event was not correct.", event.type == EventBrokerTests.SECOND_EVENT_TYPE)
			__callCount++;
		}

	}
}