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
 * The Original Code is ActionScript 3 LocalConnection Event version 0.1.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by the Initial Developer are Copyright (C) 2007
 * the Initial Developer. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.utils.events
{
	import flash.events.Event;

	/**
	 * The LocalConnectionEvent is used by the LocalConnectionManager as a single communication Event to handle
	 * the basic events that can occur duing use.  This Event type helps consolidate the different events that
	 * are dispatched by the Flash LocalConnection.
	 * 
	 * @author jpolanco
	 * @version 0.1
	 */
	public class LocalConnectionEvent extends Event
	{
		/**
		* Dispatched when the LocalConnectionManager can not connect to the requested application name.  This is usually
		* caused by another application already connected via the provided name.
		*/
		static public const CONNECTION_ERROR:String = "CONNECTION_ERROR";
		
		/**
		* When a message can not be sent properly by the LocalConnectionManager this error is dispatched.  If the error
		* is caused by a callback from another application using the LCM protocol then the event will contain details
		* about the cause of the error.
		*/
		static public const SENT_MESSAGE_ERROR:String = "SENT_MESSAGE_ERROR";
		
		/**
		* Dispatched when a status message has been sent.
		*/
		static public const STATUS_MESSAGE:String = "STATUS_MESSAGE";
		
		/**
		* Contains the error message that has been generated or received.
		*/
		public var errorMessage:String;
		
		/**
		* Stores the error ID if provided.
		*/
		public var errorID:int;
		
		/**
		* Stores the sting verison of the status message that contains the instance name that reported the error.
		*/
		public var statusMessage:String;
		
		/**
		* Contains the simple status string.
		*/
		public var status:String;
		
		/**
		* Contains the status code for a status message.
		*/
		public var statusCode:String;
		
		/**
		 * Constructor.  Same as the base Event Class.
		 * 
		 * @param type The Event Type
		 * @param bubbles Defines if the event should bubble.
		 * @param cancelable Defines if the event can be cancelled.
		 * 
		 */
		public function LocalConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}