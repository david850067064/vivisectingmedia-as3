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
	import com.vivisectingmedia.framework.controllers.interfaces.ITaskBase;
	import com.vivisectingmedia.framework.controllers.interfaces.ITaskGroup;
	import com.vivisectingmedia.framework.datastructures.utils.HashTable;
	import com.vivisectingmedia.framework.datastructures.utils.PriorityQueue;
	
	import flash.events.EventDispatcher;

	public class TaskController extends EventDispatcher
	{
		protected var taskQueue:PriorityQueue;
		protected var activeTasks:HashTable;
		protected var notReadyQueue:HashTable;
		
		private var __activeTaskLimit:uint = 1;
		
		public function TaskController()
		{
			super(this);
			
			taskQueue = new PriorityQueue();
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
			task.inQueue();
			taskQueue.addItem(task, task.priority);
			
			// call next, to check queue state
			next();
		}
		
		public function addTaskGroup(group:ITaskGroup):void
		{
			
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
			var newList:PriorityQueue = new PriorityQueue();
			var len:int = overrides.length;		
			var itemList:Array = taskQueue.items;
				
			for each(var taskBase:ITaskBase in itemList)
			{
				var match:Boolean = false;
				for(var i:uint = 0; i < len; i++) 
				{ 
					if(taskBase.type == overrides[i]) 
					{
						// found a match, cancel it
						match == true; 
						if(taskBase is ITask) ITask(taskBase).cancel();
					}
				}
				if(!match) newList.addItem(taskBase, taskBase.priority);
			}
			
			// update to the stripped list
			taskQueue = newList;
		}
		
		protected function next():void
		{
			// make sure we have tasks, if not exit
			if(!taskQueue.hasItems) return;
			
			// see if we can handle a new task
			if(activeTasks.length < __activeTaskLimit)
			{
				// we need to take action, first check ready queue then go to task queue
				var nextTask:ITaskBase = ITaskBase(taskQueue.peek());
				
				// determine if it is a task or task base
				var task:ITask;
				if(nextTask is ITaskGroup)
				{
					task = ITaskGroup(nextTask).next();
					if(!ITaskGroup(nextTask).hasTask) taskQueue.next();
				} else {
					task = ITask(taskQueue.next());
				}
				
				
				// determine if the tasks are ready
				if(task.ready)
				{
					// start the task and add it to the active task list
					task.addEventListener(TaskEvent.TASK_COMPLETE, handleTaskEvent);
					task.addEventListener(TaskEvent.TASK_CANCEL, handleTaskEvent);
					task.start();
					activeTasks.addItem(task, true);
				} else {
					// the task is not ready, add to the not ready queue
					task.addEventListener(TaskEvent.TASK_READY, handleTaskEvent);
					notReadyQueue.addItem(task, true);
					task.inWaitingForReady();
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
					task.removeEventListener(TaskEvent.TASK_READY, handleTaskEvent);
					taskQueue.addItem(task, 1); // set to one to override all but zero
					next();
				break;
			}
		}
		
	}
}