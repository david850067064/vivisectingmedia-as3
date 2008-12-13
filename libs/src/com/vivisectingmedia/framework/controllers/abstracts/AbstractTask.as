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
package com.vivisectingmedia.framework.controllers.abstracts
{
	import com.vivisectingmedia.framework.controllers.events.TaskEvent;
	import com.vivisectingmedia.framework.controllers.interfaces.ITask;
	
	import flash.events.EventDispatcher;

	/**
	 * The AbstractTask is the base class to extend all Tasks from.
	 * The TaskController does not require a Task to extend from AbstractTask, 
	 * but looks for an ITask.  The AbstractTask is provided as a starting
	 * point to define basic types, events and implementations of the required
	 * interface API. 
	 */
	[Event(name="taskReady",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")]
	[Event(name="taskCompelte",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")] 
	[Event(name="taskQueued",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")] 
	[Event(name="taskStart",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")] 
	[Event(name="taskPause",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")] 
	[Event(name="taskCancel",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")]
	[Event(name="taskError",type="com.vivisectingmedia.framework.controllers.events.TaskEvent")]   
	public class AbstractTask extends EventDispatcher implements ITask
	{
		/* STATIC PROPERTIES */
		static public const TASK_CREATED:String = "TASK_CREATED";
		
		/* PROTECTED PROPERTIES */
		protected var currentPhase:String;
		protected var currentOverrides:Array;
		
		/* PRIVATE PROPERTIES */
		private var __type:String;

		
		public function AbstractTask(type:String)
		{
			super(this);
			
			// set properties
			__type = type;
			currentOverrides = new Array();
			currentPhase = TASK_CREATED;
		}
		
		public function get priority():uint
		{
			// default is set to five, lowest default prority
			return 5;
		}
		
		public function get type():String
		{
			return __type;
		}
		
		public function get ready():Boolean
		{
			return true;
		}
		
		public function get phase():String
		{
			return currentPhase;
		}
		
		public function get taskOverrides():Array
		{
			return currentOverrides;
		}
		
		public function start():void
		{
			currentPhase = TaskEvent.TASK_START;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_START));
		}
		
		public function pause():void
		{
			currentPhase = TaskEvent.TASK_PAUSE;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_PAUSE));
		}
		
		public function cancel():void
		{
			currentPhase = TaskEvent.TASK_CANCEL;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_CANCEL));
		}
		
		public function inQueue():void
		{
			currentPhase = TaskEvent.TASK_QUEUED;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_QUEUED));
		}
		
		public function inWaitingForReady():void
		{
			currentPhase = TaskEvent.TASK_WAITING_FOR_READY;
			dispatchEvent(new TaskEvent(TaskEvent.TASK_WAITING_FOR_READY));
		}
				
	}
}