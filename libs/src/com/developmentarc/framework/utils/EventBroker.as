/* ***** BEGIN MIT LICENSE BLOCK *****
 * 
 * Copyright (c) 2009 DevelopmentArc LLC
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
 package com.developmentarc.framework.utils
{
	import flash.events.Event;
	
	/**
	 * The EventBroker is a remote Observer pattern that allows objects to subscribe to events that may be broadcasted by any item in the system.
	 * This utility is useful for situations where the broadcaster may not be a direct child or could change as the application is run.  The EventBroker
	 * allows for any object to subscribe to any event that is broadcasted through the broker.  The subscriber must provide a callback that accepts one
	 * argument of type Event.
	 * 
	 * <p>The EventBroker is a Static object which means that all access must be made through the static methods.  The class is a facade Singleton which means
	 * that even though you are calling a static method a singleton object is defined so that only one instance of the EventBroker exists.</p>
	 *  
	 * @author jpolanco
	 * 
	 */
	public class EventBroker
	{
		/* stores the singleton instance */
		static private var _inst:EventBroker;
		
		/* stores the listener/callback pairs */
		private var _eventList:Object;
		
		private var _lockQueue:Boolean = false;
		private var _itemsDuringLock:Array = [];
		
		/**
		 * CONSTRUCTOR.
		 * 
		 * @private 
		 * @param lock
		 * 
		 */
		public function EventBroker(lock:SingletonLock)
		{
			_eventList = new Array();
		}
		
		/**
		 * Enables any object to subscribe to any event type by providing the Event type and the callback method the EventBroker should call
		 * when an Event of the requested type is broadcasted.  The callback must be a single argument method that accepts type Event.
		 *  
		 * @param eventType The Event type to subscribe to.
		 * @param callback The method to call when the event type is broadcasted.
		 * 
		 */
		static public function subscribe(eventType:String, callback:Function):void
		{
			instance.addSubscriber(eventType, callback);
		}
		
		/**
		 * Called by an object that wishes to broadcast an event.  All subscribers of the event type will be called and passed the provided Event.
		 *  
		 * @param event The Event to broadcast to the subscriber set.
		 * 
		 */
		static public function broadcast(event:Event):void
		{
			instance.broadcastMessage(event);	
		}
		
		/**
		 * Removes subscription of the specified event and callback.
		 *  
		 * @param eventType
		 * @param callback
		 * 
		 */
		static public function unsubscribe(eventType:String, callback:Function):void
		{
			instance.removeSubscriber(eventType, callback);
		}
		
		/**
		 * Removes all subscribed methods and objects from the EventBroker. 
		 * 
		 */
		static public function clearAllSubscriptions():void
		{
			instance.clean();
		}
		
		/**
		 * Hidden singleton instance that is called from the facade static API.
		 *  
		 * @return 
		 * 
		 */
		static private function get instance():EventBroker
		{
			if(!_inst) _inst = new EventBroker(new SingletonLock());
			return _inst;			
		}
		
		/*
		 * subscribes the event.
		 * 
		 */
		private function addSubscriber(eventType:String, callback:Function):void
		{
			// prevent items from being added while broadcasting
			if(_lockQueue)
			{
				_itemsDuringLock.push(new QueueParam(QueueParam.ADD, eventType, callback));
				return;
			}
			
			var callbackList:Array;
			if(_eventList.hasOwnProperty(eventType))
			{
				// see if we already have it
				callbackList = _eventList[eventType] as Array;
				var len:int = callbackList.length;
				for(var i:uint = 0; i < len; i++) if(callbackList[i] == callback) return;
				
				// we must not, add it
				callbackList.push(callback);

			} else {
				// create a new one
				callbackList = new Array();
				callbackList.push(callback);
				_eventList[eventType] = callbackList;
			}
		}
		
		/*
		 * removes the subscription.
		 * 
		 */
		private function removeSubscriber(eventType:String, callback:Function):void
		{
			// prevent items from being deleted while broadcasting
			if(_lockQueue)
			{
				_itemsDuringLock.push(new QueueParam(QueueParam.REMOVE, eventType, callback));
				return;
			}
			
			var callbackList:Array;
			if(_eventList.hasOwnProperty(eventType))
			{
				// find the callback
				callbackList = _eventList[eventType] as Array;
				var len:int = callbackList.length;
				for(var i:uint = 0; i < len; i++)
				{
					if(callbackList[i] == callback)
					{
						// remove the callback
						callbackList.splice(i, 1);
						
						// see if we have anymore callbacks
						if(callbackList.length < 1)
						{
							// remove the eventtype
							_eventList[eventType] = null;
							delete _eventList[eventType];
						}
					}
				}
			}
		}
		
		/*
		 * broadcasts the message
		 * 
		 */
		private function broadcastMessage(event:Event):void
		{
			_lockQueue = true;
			if(_eventList.hasOwnProperty(event.type))
			{
				var callbackList:Array = _eventList[event.type] as Array;
				var len:int = callbackList.length;
				for(var i:uint = 0; i < len; i++)
				{
					var callback:Function = callbackList[i] as Function;
					if(callback != null) callback.call(this, event);
				}
			}
			_lockQueue = false;
			if(_itemsDuringLock.length > 0) clearQueue();
		}
		
		private function clearQueue():void
		{
			var len:int = _itemsDuringLock.length;
			for(var i:uint = i; i < len; i++)
			{
				var item:QueueParam = QueueParam(_itemsDuringLock[i]);
				switch(item.type)
				{
					case QueueParam.ADD:
						addSubscriber(item.eventType, item.callback);
					break;
					
					case QueueParam.REMOVE:
						removeSubscriber(item.eventType, item.callback);
					break;
				}
			}
			
			_itemsDuringLock = new Array();
		}
		
		private function clean():void
		{
			_eventList = new Object();
			_itemsDuringLock = new Array();
			_lockQueue = false;
		}

	}
}

class QueueParam
{
	static public const ADD:String = "ADD";
	static public const REMOVE:String = "REMOVE";
	
	public var type:String;
	public var eventType:String;
	public var callback:Function;
	
	public function QueueParam(t:String, e:String, c:Function)
	{
		type = t;
		eventType = e;
		callback = c;
	}
}

class SingletonLock
{
	public function SingletonLock()
	{
		// constructor
	}
}