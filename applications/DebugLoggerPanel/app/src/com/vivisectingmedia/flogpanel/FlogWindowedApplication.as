package com.vivisectingmedia.flogpanel
{
	import com.vivisectingmedia.framework.utils.LocalConnectionManager;
	import com.vivisectingmedia.framework.utils.events.LocalConnectionEvent;
	import com.vivisectingmedia.framework.utils.logging.DebugLogger;
	import com.vivisectingmedia.framework.utils.logging.DebugMessage;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.controls.TextArea;
	import mx.core.WindowedApplication;

	public class FlogWindowedApplication extends WindowedApplication
	{
		public var debugMessages:Array;
		public var maxMessages:int = 1000;
		
		[Bindable] public var messageFilterTypes:ArrayCollection;
		[Bindable] public var filteredMessageList:ArrayCollection;
		
		// COMPONENTS
		[Bindable] public var status_field:TextArea;
		[Bindable] public var filter_list:ComboBox;
		
		protected var connection:LocalConnectionManager;
		
		private var _connected:Boolean = false;
		
		public function FlogWindowedApplication()
		{
			super();
			debugMessages = new Array();
			filteredMessageList = new ArrayCollection();
			defineFilters();
		}
		
		protected function defineFilters():void
		{
			// define filters
			messageFilterTypes = new ArrayCollection();
			messageFilterTypes.addItem({name:"ALL", value: DebugMessage.INFO});
			messageFilterTypes.addItem({name:"DEBUG", value: DebugMessage.DEBUG});
			messageFilterTypes.addItem({name:"WARN", value: DebugMessage.WARN});
			messageFilterTypes.addItem({name:"ERROR", value: DebugMessage.ERROR});
			messageFilterTypes.addItem({name:"FATAL", value: DebugMessage.FATAL});
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			status_field.htmlText = "<font color='#009900'>looking for connection...</font>";
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
				status_field.htmlText += "<font color='#009900'>connection made.</font>";
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
					trace("fPanel: connection error");
				break;
				
				case LocalConnectionEvent.SENT_MESSAGE_ERROR:
					trace("fPanel: connection message error -- " + event.errorMessage);
				break;
				
				case LocalConnectionEvent.STATUS_MESSAGE:
					if(event.status == "error")
					{
						if(_connected)
						{
							status_field.htmlText += "unknown error has occured.";
						}
					}
				break;
			}
		}
	}
}