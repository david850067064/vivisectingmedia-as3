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
	public class ClassDebugLogger
	{
		private var _class:Class;
		public function ClassDebugLogger(classReference:Class)
		{
			_class = classReference;
		}
		
		/**
		 * @see DebugLogger.info
		 *  
		 * @param message Text message to be dispatched and displayed.
		 * @param methodReference The method in which the message was generated. Optional
		 * 
		 */
		public function info(message:String, method:String = ""):void
		{
			DebugLogger.info(message, _class, method);
		}
		
		/**
		 * @see DebugLogger.debug
		 *  
		 * @param message Text message to be dispatched and displayed.
		 * @param method The method in which the message was generated. Optional
		 * 
		 */
		public function debug(message:String, method:String = ""):void
		{
			DebugLogger.debug(message, _class, method);
		}
		
		/**
		 * @see DebugLogger.warn
		 *  
		 * @param message Text message to be dispatched and displayed.
		 * @param method The method in which the message was generated. Optional
		 * 
		 */
		public function warn(message:String, method:String = ""):void
		{
			DebugLogger.warn(message, _class, method);
		}
		
		/**
		 * @see DebugLogger.debug
		 *  
		 * @param message Text message to be dispatched and displayed.
		 * @param method The method in which the message was generated. Optional
		 * 
		 */
		public function error(message:String, method:String = ""):void
		{
			DebugLogger.error(message, _class, method);
		}
		
		/**
		 * @see DebugLogger.fatal
		 *  
		 * @param message Text message to be dispatched and displayed.
		 * @param method The method in which the message was generated. Optional
		 * 
		 */
		public function fatal(message:String, method:String = ""):void
		{
			DebugLogger.fatal(message, _class, method);
		}

	}
}