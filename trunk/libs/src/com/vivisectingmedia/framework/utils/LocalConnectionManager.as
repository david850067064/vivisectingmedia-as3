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
 * The Original Code is ActionScript 3 LocalConnection Manager version 0.1.
 *
 * The Initial Developer of the Original Code is
 * James Polanco (www.vivisectingmedia.com).
 * Report issues to james [at] vivisectingmedia.com
 * Portions created by the Initial Developer are Copyright (C) 2007
 * the Initial Developer. All Rights Reserved.
 *
 *
 * ***** END LICENSE BLOCK ***** */
package com.vivisectingmedia.framework.utils
{
	import com.vivisectingmedia.framework.utils.events.LocalConnectionEvent;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * <p>The LocalConnectionManager provides a simpler interface to the Flash LocalConnection that is designed to support
	 * retention of Class type when communication with other ActionScript 3 Applications.  For Class retention to work
	 * both Application must contain the custom class.  If the class does not existing in the receiving Application an
	 * error event will be dispatched.</p>
	 * 
	 * <p>To use this utility create a new instance of the Class providing the target Object that methods send from another 
	 * LocalConnection should be applied to, create a connection to expose this application to other LCM enabled applications
	 * and then brodacast messages with sendMessage() method. </p>
	 * 
	 * @author jpolanco
	 * 
	 */
	public class LocalConnectionManager extends EventDispatcher
	{
		
		/**
		* Stores the LC instance for the Class.
		*/
		protected var connection:LocalConnection;
		
		/**
		* Stores the connection target object that should be called when a message from the LC is received.
		*/
		protected var connectionTarget:Object;
		
		/**
		* Stores the connection name for the current application for communication.
		*/
		protected var currentConnectionName:String;
		
		/**
		 * <p>Constructor.  Creates a new instance of a LCM and establishes the LocalConnection instance during construction.</p>
		 * 
		 * <p>The constructor also opens the application for communication with other LCM enabled applications based on the name provided.  For other LCM
		 * enabled apps to successfully communicate the app must be on an approved domain and know the name that is defined for
		 * this application. Only one application at a time can be connected via the provided name.  If an application is already
		 * connected via this name the LCM will dispatch a LocalConnectionEvent.CONNECTION_ERROR.  If a connection name is not provided then
		 * the two error communication will not be able to function, this is why the argument is required.</p>
		 * 
		 * @param connTarget This is the object that LC message calls are applied to when received from another applicaiton.
		 * @param connectionName The application communication name
		 * @param domainList An array of domains to allow communication with the LC, if no value is set the default is '*'. 
		 * @param eventTarget See EventDispatcher for full details.
		 * 
		 */
		public function LocalConnectionManager(connTarget:Object, connectionName:String, domainList:Array = null, eventTarget:IEventDispatcher=null)
		{
			super(eventTarget);
			
			connectionTarget = connTarget;
			
			// create connection
			connection = new LocalConnection();
			connection.client = this;
			if(domainList)
			{
				connection.allowDomain(domainList);
			} else {
				connection.allowDomain("*");
			}
			
			
			// register events
			connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleAsyncEvent);
			connection.addEventListener(StatusEvent.STATUS, handleStatusEvent);
			
			try
			{
				// try to connect based on the provided name
				connection.connect(connectionName);
				currentConnectionName = connectionName;
			} catch (e:Error) {
				// unable to connect, probable cause is existing connection
				var event:LocalConnectionEvent = new LocalConnectionEvent(LocalConnectionEvent.CONNECTION_ERROR);
				event.errorMessage = e.message;
				event.errorID = e.errorID;
				dispatchEvent(event);
			}
		}
		
		/**
		 * Updates the approved domain list on the LocalConnection.
		 * 
		 * @param domainArray A list of strings that represent the allowed domains.
		 * 
		 */
		public function addDomain(domainArray:Array):void
		{
			connection.allowDomain(domainArray);
		}
		
		/**
		 * DO NOT USE.  This method is a communication method that is used by the connecting LCM applications.  This method is exposed
		 * as public only to allow access by the LC.
		 * 
		 * @private
		 * @param aliasList
		 * 
		 */
		public function registerTypes(aliasList:Array, caller:String):void
		{
			// register any alias
			var len:int = aliasList.length;
			for(var i:uint; i < len; i++)
			{
				var path:String = aliasList[i];
				try 
				{
					// get the class instance and register
					var classInst:Class = getDefinitionByName(path) as Class;
					registerClassAlias( path, classInst );
				} catch (e:Error) {
					// inform the caller that an error has occured.
					connection.send(caller, "messageError", "registerTypes", ("type does not exist on receving application: " + path), currentConnectionName);
					
					// class does not exisit within the application
					var lce:LocalConnectionEvent = new LocalConnectionEvent(LocalConnectionEvent.SENT_MESSAGE_ERROR);
					lce.errorID = 5001;
					lce.errorMessage = "The requested class " + path + " does not exist in this application.";
					dispatchEvent(lce);
				}
			}
		}
		
		/**
		 * DO NOT USE.  This method is a communication method that is used by the connecting LCM applications.  This method is exposed
		 * as public only to allow access by the LC.
		 * 
		 * @private
		 * @param aliasList
		 * 
		 */
		public function message(methodName:String, argList:Array, caller:String):void
		{
			// determine if target has requested method
			var found:Boolean = false;
			var classInfo:XML = describeType(connectionTarget);
			for each(var method:XML in classInfo..method)
			{
				if(method.@name == methodName)
				{
					found = true;
					break;
				}
			}
			
			// call the method or dispatch an error
			if(found)
			{
				try
				{
					connectionTarget[methodName].apply(connectionTarget, argList);
				} catch (e:Error) {
					
					// inform the caller that an error has occured.
					connection.send(caller, "messageError", methodName, e.message, currentConnectionName);
					
					// dispatch so the current application can handle the error
					var lce:LocalConnectionEvent = new LocalConnectionEvent(LocalConnectionEvent.SENT_MESSAGE_ERROR);
					lce.errorID = e.errorID;
					lce.errorMessage = e.message + " on " + currentConnectionName;
					dispatchEvent(lce);
				}
			} else {
				// method not found on target
				connection.send(caller, "messageError", methodName, "unable to find requested method", currentConnectionName);
			}
		}
		
		/**
		 * DO NOT USE.  This method is a communication method that is used by the connecting LCM applications.  This method is exposed
		 * as public only to allow access by the LC.
		 * 
		 * @private
		 * @param aliasList
		 * 
		 */
		public function messageError(methodName:String, errorString:String, callee:String):void
		{	
			// status message has been dispatched
			var lce:LocalConnectionEvent = new LocalConnectionEvent(LocalConnectionEvent.SENT_MESSAGE_ERROR);
			lce.errorID = 5000;
			lce.errorMessage = "error calling method " + methodName + " on " + callee + ": " + errorString +".";
			dispatchEvent(lce);
		}
		
		/**
		 * Used to track Async errors from the LC instance.
		 * 
		 * @param event AsyncEvent thrown by the LC.
		 * 
		 */
		protected function handleAsyncEvent(event:AsyncErrorEvent):void
		{
			// async has occurred, we could not connenct to the object
			var lce:LocalConnectionEvent = new LocalConnectionEvent(LocalConnectionEvent.SENT_MESSAGE_ERROR);
			lce.errorID = event.error.errorID;
			lce.errorMessage = event.error.message + " on " + currentConnectionName;
			dispatchEvent(lce);
		}
		
		/**
		 * Used to track Status events from the LC instance.
		 * 
		 * @param event Status event from the LC.
		 * 
		 */
		protected function handleStatusEvent(event:StatusEvent):void
		{
			// status message has been dispatched
			var lce:LocalConnectionEvent = new LocalConnectionEvent(LocalConnectionEvent.STATUS_MESSAGE);
			lce.statusMessage = event.level + " on " + currentConnectionName;
			lce.status = event.level;
			lce.statusCode = event.code;
			dispatchEvent(lce);
		}
		
		/**
		 * Calls the application via the target name and method defined in the arguments.  This method retains the Class definitions
		 * and marks the arguments according to their type so that the receiving application can re-cast back to the correct Class. The
		 * receiving application must have the same defined type and the method argument count must match both order and type in order
		 * for the call to be successfully completed.
		 * 
		 * @param target The name of the application exposed via connectionName to call the method on.
		 * @param methodName The method to call on the target application.
		 * @param args Common seperated argument values for the defined method.
		 * 
		 */
		public function sendMessage(target:String, methodName:String, ...  args):void
		{
			var argList:Array = new Array();
			var aliasList:Array = new Array();
			
			// type all the arguments
			if(args)
			{
				var len:int = args.length;
				for(var i:uint; i < len; i++)
				{
					var item:Object = args[i];
					var path:String = getQualifiedClassName(item)
					if(path.indexOf("::") > -1)
					{
						var seperator:int = path.indexOf("::");
						path = path.substr(0, seperator) + "." + path.substr((seperator + 2), path.length);
					}
					var classInst:Class = getDefinitionByName(path) as Class;
					registerClassAlias( path, classInst );
					aliasList.push(path);
					argList.push(item);
				}
			}
			connection.send(target, "registerTypes", aliasList, currentConnectionName);
			connection.send(target, "message", methodName, argList, currentConnectionName); 
		}
		
	}
}