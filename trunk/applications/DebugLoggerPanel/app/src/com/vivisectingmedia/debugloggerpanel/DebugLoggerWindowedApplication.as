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
package com.vivisectingmedia.debugloggerpanel
{
	import com.vivisectingmedia.debugloggerpanel.models.DataModel;
	import com.vivisectingmedia.framework.utils.LocalConnectionManager;
	import com.vivisectingmedia.framework.utils.events.LocalConnectionEvent;
	import com.vivisectingmedia.framework.utils.logging.DebugLogger;
	import com.vivisectingmedia.framework.utils.logging.DebugMessage;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.controls.TextArea;
	import mx.core.WindowedApplication;

	/**
	 * The DebugLoggerWindowedApplication is the backing Application class for
	 * the DebugLogger AIR Panel. 
	 * 
	 * @author James Polanco
	 * 
	 */
	public class DebugLoggerWindowedApplication extends WindowedApplication
	{
		public var debugMessages:Array;
		public var maxMessages:int = 1000;
		
		/* PUBLIC PROPERTIES */
		[Bindable] public var messageFilterTypes:ArrayCollection;
		[Bindable] public var filteredMessageList:ArrayCollection;
		
		/* PUBLIC COMPONENTS */
		[Bindable] public var status_field:TextArea;
		[Bindable] public var filter_list:ComboBox;
		
		/* PROTECTED PROPERTIES */
		protected var connection:LocalConnectionManager;
		protected var model:DataModel;
		
		/* PRIVATE PROPERTES */
		private var _connected:Boolean = false;
		
		public function DebugLoggerWindowedApplication()
		{
			super();
			debugMessages = new Array();
			filteredMessageList = new ArrayCollection();
			model = DataModel.instance;
			defineFilters();
		}
		
		protected function defineFilters():void
		{
			// define filters
			messageFilterTypes = new ArrayCollection();
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_all'), value: DebugMessage.INFO});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_debug'), value: DebugMessage.DEBUG});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_warn'), value: DebugMessage.WARN});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_error'), value: DebugMessage.ERROR});
			messageFilterTypes.addItem({name:resourceManager.getString('strings', 'message_fatal'), value: DebugMessage.FATAL});
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			model.addConsuleText(resourceManager.getString('strings', 'console_connection_waiting'));
			connection = new LocalConnectionManager(this, DebugLogger.DEBUG_LOGGER_SUBSCRIBER);
			
			// register events
			connection.addEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleConnectionEvent);
			connection.addEventListener(LocalConnectionEvent.SENT_MESSAGE_ERROR, handleConnectionEvent);
			connection.addEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleConnectionEvent);
			
			var msg:DebugMessage = new DebugMessage("creation", DebugMessage.HANDSHAKE);
			connection.sendMessage(DebugLogger.DEBUG_LOGGER_BROADCASTER, "messageHandshake", msg);
			
		}
		
		public function debugMessageSent(msg:DebugMessage):void
		{
			if(!_connected)
			{
				_connected = true;
				model.addConsuleText(resourceManager.getString('strings', 'console_connection_made'));
			}
			
			// add item to the list
			if(debugMessages.length >= maxMessages) debugMessages.shift();
			debugMessages.push(msg);
			
			// add to filter if required
			var level:Number = filter_list.selectedItem.value;
			if(msg.type >= level)
			{
				if(filteredMessageList.length >= maxMessages) filteredMessageList.removeItemAt(0);
				filteredMessageList.addItem(msg);
			}
		}
		
		public function connectToClient(msg:DebugMessage):void
		{
			if(!_connected && msg.type == DebugMessage.HANDSHAKE)
			{
				var msg:DebugMessage = new DebugMessage("creation", DebugMessage.HANDSHAKE);
				connection.sendMessage(DebugLogger.DEBUG_LOGGER_BROADCASTER, "messageHandshake", msg);
			}
		}
		
		public function filterMessages():void
		{
			var level:Number = filter_list.selectedItem.value;
			filteredMessageList.removeAll();
			var len:int = debugMessages.length;
			for(var i:uint; i < len; i++)
			{
				var msg:DebugMessage = DebugMessage(debugMessages[i]);
				if(msg.type >= level)
				{
					filteredMessageList.addItem(msg);
				}
			}
		}
		
		protected function handleConnectionEvent(event:LocalConnectionEvent):void
		{
			switch(event.type)
			{
				case LocalConnectionEvent.CONNECTION_ERROR:
					model.addConsuleText(resourceManager.getString('errors', 'console_connection'), DataModel.MESSAGE_ERROR);
				break;
				
				case LocalConnectionEvent.SENT_MESSAGE_ERROR:
					var msg:String = resourceManager.getString('errors', 'console_sent_connection') + event.errorMessage;
					model.addConsuleText(msg, DataModel.MESSAGE_ERROR);
				break;
				
				case LocalConnectionEvent.STATUS_MESSAGE:
					if(event.status == "error")
					{
						if(_connected)
						{
							model.addConsuleText(resourceManager.getString('errors', 'console_unknow'), DataModel.MESSAGE_ERROR);
						}
					}
				break;
			}
		}
	}
}