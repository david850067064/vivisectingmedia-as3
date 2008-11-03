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
package com.vivisectingmedia.framework.controllers
{
	import com.vivisectingmedia.framework.controllers.events.TaskEvent;
	import com.vivisectingmedia.framework.controllers.interfaces.ITask;
	import com.vivisectingmedia.framework.datastructures.utils.HashTable;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class TaskController extends EventDispatcher
	{
		protected var taskQueue:Array;
		
		protected var activeTasks:HashTable;
		protected var notReadyQueue:HashTable;
		
		private var __activeTaskLimit:uint = 1;
		
		public function TaskController()
		{
			super(this);
			
			taskQueue = new Array();
			
			activeTasks = new HashTable();
			notReadyQueue = new HashTable();
		}
		
		public function set activeTaskLimit(value:uint):void
		{
			__activeTaskLimit = value;
		}
		
		public function get activeTaskLimit():uint
		{
			return __activeTaskLimit;
		}
		
		public function addTask(task:ITask):void
		{
			// apply overrides
			applyOverrides(task.taskOverrides);
			
			// determine priority and placement
			addToQueue(task);
			
			// call next, to check queue state
			next();
		}
		
		/**
		 * Used to find and remove any tasks in the current
		 * queue that are overriden by a new task that has been
		 * added to the controller.
		 * 
		 * @param overrides List of task types to find and removed.
		 * 
		 */
		protected function applyOverrides(overrides:Array):void
		{
			if(overrides.length < 1) return; // no overrides
			
			// loop over and find all the matched type
			var newList:Array = new Array();
			var len:int = overrides.length;			
			for each(var task:ITask in taskQueue)
			{
				var match:Boolean = false;
				for(var i:uint = 0; i < len; i++) 
				{ 
					if(task.type == overrides[i]) 
					{
						// found a match, cancel it
						match == true; 
						task.cancel();
					}
				}
				if(!match) newList.push(task);
			}
			
			// update to the stripped list
			taskQueue = newList;
		}
		
		protected function addToQueue(task:ITask):void
		{
			// verify we have tasks
			task.inQueue();
			var len:int = taskQueue.length;
			if(len < 1)
			{
				// we have no tasks, add and exit
				taskQueue.push(task);
				return;
			}
			
			// determine the placement
			for(var i:uint = 0; i < len; i++)
			{
				var item:ITask = ITask(taskQueue[i]);
				if(task.priority > item.priority)
				{
					// found placement... add then break
					var placement:int = ((i - 1) < 0) ? 0 : (i - 1);
					taskQueue = taskQueue.splice(placement, 0, task);
					return;
				}
			}
		}
		
		protected function next():void
		{
			// make sure we have tasks, if not exit
			if(taskQueue.length < 1) return;
			
			// see if we can handle a new task
			if(activeTasks.length < __activeTaskLimit)
			{
				// we need to take action, and get the next task
				var nextTask:ITask = ITask(taskQueue.shift());
				
				// determine if the tasks are ready
				if(nextTask.ready)
				{
					// start the task and add it to the active task list
					nextTask.addEventListener(TaskEvent.TASK_COMPLETE, handleTaskEvent);
					nextTask.addEventListener(TaskEvent.TASK_CANCEL, handleTaskEvent);
					nextTask.start();
					activeTasks.addItem(nextTask, true);
				} else {
					// the task is not ready, add to the not ready queue
					nextTask.addEventListener(TaskEvent.TASK_READY, handleTaskEvent);
					notReadyQueue.addItem(nextTask, true);
					nextTask.inWaitingForReady();
					next();
				}
			}
		}
		
		protected function handleTaskEvent(event:TaskEvent):void
		{
			var task:ITask = ITask(event.currentTarget);
			switch(event.type)
			{
				case TaskEvent.TASK_CANCEL:
				case TaskEvent.TASK_COMPLETE:
					// remove from the active queue
					activeTasks.remove(task);
					task.removeEventListener(TaskEvent.TASK_COMPLETE, handleTaskEvent);
					task.removeEventListener(TaskEvent.TASK_CANCEL, handleTaskEvent);
					next();
				break;
				
				case TaskEvent.TASK_READY:
					// remove from the not ready task, add to the front of the line and call next
					notReadyQueue.remove(task);
					taskQueue.unshift(task);
					task.removeEventListener(TaskEvent.TASK_READY, handleTaskEvent);
					next();
				break;
			}
		}
		
	}
}