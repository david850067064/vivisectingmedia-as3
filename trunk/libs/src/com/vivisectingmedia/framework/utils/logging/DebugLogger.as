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
package com.vivisectingmedia.framework.utils.logging
{
	public class DebugLogger
	{
		// PRIVATE
		static private var _inst:DebugLog; // stores singleton instance
		static private var __enabled:Boolean = true; // determines if the logging messages should be processed
		static private var __cacheLimit:int = 500; // the default limit of the cache
		static private var __messageLevel:int = DebugMessage.INFO // the current message level
		
		// PUBLIC CONSTANTS				
		/**
		 * Represents the unique identifier for the Debug Logger that is used by the Local Connection to communicate with the
		 * fLogger Application Panel.
		 */		
		static public const DEBUG_LOGGER_BROADCASTER:String = "_DEBUG_LOGGER_BROADCASTER";
		
		/**
		 * Represents the unique identifier for the listener application (fLogger panel) that wishes to subscribe to messages
		 * dispatched by the fLogger. 
		 */
		static public const DEBUG_LOGGER_SUBSCRIBER:String = "_DEBUG_LOGGER_SUBSCRIBER";
		
		/**
		 * Represents the method name that is used by the subscriber to announce its presence on launch.
		 */		
		static public const DEBUG_LOGGER_HANDSHAKE:String = "messageHandshake";
		
		/**
		 * Represents the method name that the dLogger uses to broadcast messges to the current subscriber.
		 */		
		static public const DEBUG_LOGGER_MESSAGE:String = "debugMessageSent";
		
		// PUBLIC METHODS
		
		/**
		 * Dispatches an INFO level message to either the log cache or the active fLogger UI tool.  INFO messages are the lowest level of log statements
		 * and are intended to provide basic messages such as construction of an object, calls to a method, etc.
		 *  
		 * @param message Text message to be dispatched and displayed.
		 * 
		 */
		static public function info(message:String):void
		{
			if(!__enabled) return;
			if(__messageLevel > DebugMessage.INFO) return;
			instance.sendMessage(message, DebugMessage.INFO);
		}
		
		/**
		 * Dispatches a DEBUG level message to either the log cache or the active fLogger UI tool.  DEBUG messages are intended for developers who need
		 * log statements that can be filtered above INFO messages but are only useful during development.  DEBUG message should be removed once the intended
		 * issue has been resolved.
		 * 
		 * @param message Text message to be dispatched and displayed.
		 * 
		 */
		static public function debug(message:String):void
		{
			if(!__enabled) return;
			if(__messageLevel > DebugMessage.DEBUG) return;
			instance.sendMessage(message, DebugMessage.DEBUG);
		}
		
		/**
		 * Dispatches a WARN level message to either the log cache or the active fLogger UI tool.  WARN messges are intended to inform developers that
		 * some issue within the system has occured and should be reviewed for possible errors.  Warinings are not considered an error and may be an
		 * acceptable issue in some cases.
		 * 
		 * @param message Text message to be dispatched and displayed.
		 * 
		 */
		static public function warn(message:String):void
		{
			if(!__enabled) return;
			if(__messageLevel > DebugMessage.WARN) return;
			instance.sendMessage(message, DebugMessage.WARN);
		}
		
		/**
		 * Dispatches an ERROR level message to either the log cache or the active fLogger UI tool.  ERROR messges are intended to inform developers
		 * that a serious issue has occured that may cause system instability.  Errors should be reviewed immediately and the cause of the error should
		 * be resolved before release.
		 * 
		 * @param message Text message to be dispatched and displayed.
		 * 
		 */
		static public function error(message:String):void
		{
			if(!__enabled) return;
			if(__messageLevel > DebugMessage.ERROR) return;
			instance.sendMessage(message, DebugMessage.ERROR);
		}
		
		/**
		 * Dispatches a FATAL level message to either the log cache or the active fLogger UI tool.  FATAL messges are intended to inform developers
		 * that the application can no longer continue operation.  Fatal errors are the highest level of failure.
		 * 
		 * @param message Text message to be dispatched and displayed.
		 * 
		 */
		static public function fatal(message:String):void
		{
			if(!__enabled) return;
			instance.sendMessage(message, DebugMessage.FATAL);
		}
		
		/**
		 * Defines the debugging state of fLogger.  When fLogger is disabled the debugging cached is cleared and all messages are
		 * ignored by the DebugLogger Class.  By default the fLogger is enabled and messages are stored in cache.  It is recommended
		 * that in your application that code is added to determine if the application is in debug mode and if not the set the debugginEnabled
		 * value to false to prevent un-needed memory usage for cache and message creation.
		 *  
		 * @param enabled True enables debug logging, Flase disables.
		 * 
		 */
		static public function set debuggingEnabled(enabled:Boolean):void
		{
			__enabled = enabled;
			instance.setDebugging(enabled);
		}
		
		static public function get debuggingEnabled():Boolean
		{
			return __enabled;
		}
		
		/**
		 * Defines the number of cached items that should be stored before the fist item in the cache is removed.  If the cache limit is reached before
		 * an active connection is made the first chached message is removed and the new cached message is added to the stack.  This continues until an
		 * active connection by the fLogger UI is made which then clears the cache and caching is then disabled.
		 *  
		 * @param value Maximum number of items to hold in the cache.
		 * 
		 */
		static public function set cacheLimit(value:int):void
		{
			__cacheLimit = value;
			instance.setCacheLimit(value);
		}
		
		static public function get cacheLimit():int
		{
			return __cacheLimit;
		}
		
		/**
		 * Defines the minimum message level that is logged.
		 * 
		 * @param level
		 * 
		 */
		static public function set messageLevel(level:int):void
		{
			switch(level)
			{
				// set all to the level unless info or an invalid level
				case DebugMessage.ERROR:
				case DebugMessage.WARN:
				case DebugMessage.FATAL:
				case DebugMessage.DEBUG:
					__messageLevel = level;
				break;
				
				default:
					__messageLevel = DebugMessage.INFO;
			}
			
			instance.setMessageLevel(__messageLevel);
		}
		
		// PRIVATE METHODS
		
		/*
		 * Used to manage a singleton pattern without developers requiring knowledge of instance.  This also prevents exposure of public methods
		 * on the class itself and allows a private class to be the main instance that handles cache and message management.
		 *
		 */
		static private function get instance():DebugLog
		{
			// check if instance exists, return instance
			if(!_inst) _inst = new DebugLog();
			return _inst;
		}

	}
}

/* PRIVTE SINGLETON CLASS */

import com.vivisectingmedia.flog.DebugLogger;
import com.vivisectingmedia.flog.DebugMessage;
import com.vivisectingmedia.framework.utils.LocalConnectionManager;
import com.vivisectingmedia.framework.utils.events.LocalConnectionEvent;
	

class DebugLog
{
	static public const DEFAULT_CACHE_LIMIT:int = 500;
	
	private var _cacheLog:Array;
	private var _cacheLimit:int = DEFAULT_CACHE_LIMIT;
	private var _messageLevel:int = 0;
	private var _inCache:Boolean = true;
	private var _enabled:Boolean = true;
	
	private var _connection:LocalConnectionManager;
	
	
	public function DebugLog()
	{
		// Constructor
		_cacheLog = new Array();
		_cacheLog.push(new DebugMessage("*** START MESSAGE CACHE ***", DebugMessage.SYSTEM_MESSAGE));
		
		startConnection();
	}
	
	public function setDebugging(value:Boolean):void
	{
		if(value)
		{
			// enable debugging
			_enabled = true;
			if(!_connection) startConnection();
		} else {
			// disable debugging
			_enabled = false;
			endConnection();
			_cacheLog = new Array();
		}
	}
	
	public function setCacheLimit(value:int):void
	{
		_cacheLimit = value;
		if(_cacheLog.length > _cacheLimit)
		{
			// determine difference and splice log
			var diff:int = _cacheLog.length - _cacheLimit;
			_cacheLog.splice(0, diff);
		}
	}
	
	public function setMessageLevel(level:int):void
	{
		_messageLevel = level;
		if(_inCache)
		{
			// clear out all the non-level messages
			var len:int = _cacheLog.length;
			var newCache:Array = new Array();
			for(var i:uint; i < len; i++)
			{
				var msg:DebugMessage = DebugMessage(_cacheLog[i]);
				if(msg.type >= level)
				{
					newCache.push(msg);
				}
			}
			
			_cacheLog = newCache;
		}
	}
	
	public function sendMessage(msg:String, type:int):void
	{
		if(!_enabled) return;
		var dMsg:DebugMessage = new DebugMessage(msg, type);
		
		// if in cache store in cache, else broadcast message
		if(_inCache)
		{
			if(_cacheLog.length >= _cacheLimit)
			{
				// pull off the first item
				_cacheLog.shift();
			}
			_cacheLog.push(dMsg);
		} else {
			dispatchMessage(dMsg);
		}
	}
	
	public function messageHandshake(msg:DebugMessage):void
	{
		if(!_enabled || !_inCache) return;
		if(msg.type == DebugMessage.HANDSHAKE)
		{
			// connection is live
			_inCache = false;
			clearQueue();
		}
	}
	
	public function handleConnectionEvents(event:LocalConnectionEvent):void
	{
		switch(event.type)
		{
			case LocalConnectionEvent.CONNECTION_ERROR:
				trace("debugLog: connection error.");
			break;
			
			case LocalConnectionEvent.SENT_MESSAGE_ERROR:
				trace("debugLog: connection message error -- " + event.errorMessage);
			break;
			
			case LocalConnectionEvent.STATUS_MESSAGE:
				trace("debugLog: status -- " + event.statusMessage);
			break;
		}
	}
	
	/* Called when a connection is made to the  */
	public function clearQueue():void
	{
		// dispatch queue
		var len:int = _cacheLog.length;
		for(var i:uint; i < len; i++)
		{
			dispatchMessage(DebugMessage(_cacheLog[i]));
		}
		
		// send end cache
		dispatchMessage(new DebugMessage("*** END MESSAGE CACHE ***", DebugMessage.SYSTEM_MESSAGE));
		
		// clear the cache
		_cacheLog = new Array();
	}
	
	public function dispatchMessage(msg:DebugMessage):void
	{
		_connection.sendMessage(DebugLogger.DEBUG_LOGGER_SUBSCRIBER, "debugMessageSent", msg);
	}
	
	internal function startConnection():void
	{
		_connection = new LocalConnectionManager(this, DebugLogger.DEBUG_LOGGER_BROADCASTER);
		_connection.addEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleConnectionEvents);
		_connection.addEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleConnectionEvents);
		
		var msg:DebugMessage = new DebugMessage("creation", DebugMessage.HANDSHAKE);
		_connection.sendMessage(DebugLogger.DEBUG_LOGGER_SUBSCRIBER, "connectToClient", msg);
	}
	
	internal function endConnection():void
	{
		_connection.removeEventListener(LocalConnectionEvent.CONNECTION_ERROR, handleConnectionEvents);
		_connection.removeEventListener(LocalConnectionEvent.STATUS_MESSAGE, handleConnectionEvents);
		_connection = null;
	}
}