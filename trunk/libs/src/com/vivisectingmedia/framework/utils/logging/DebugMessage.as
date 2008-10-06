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
	public class DebugMessage
	{
		// CONSTANT TYPES
		static public const INFO:int = 0;
		static public const DEBUG:int = 1;
		static public const WARN:int = 2;
		static public const ERROR:int = 3;
		static public const FATAL:int = 4;
		
		// SPECIAL MESSAGE TYPES
		static public const HANDSHAKE:int = 200;
		static public const SYSTEM_MESSAGE:int = 201;
		
		public var time:Date;
		public var message:String;
		public var type:int;
		
		/**
		 * Creates a new debug message that is used to pass data from the DebugLogger to the fLogger UI tool.
		 *  
		 * @param msg Text message to display in the UI.
		 * @param msgType The message level.
		 * @param passedTime The time the message stores as the creation time.
		 * 
		 */
		public function DebugMessage(msg:String = "", msgType:int = 0, passedTime:Date = null)
		{
			super();
			message = msg;
			type = msgType;
			if(time)
			{
				// set the time
				time = passedTime; 
			} else {
				// use the creation as the time
				time = new Date();
			}
		}

	}
}