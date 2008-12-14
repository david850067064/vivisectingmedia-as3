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
package com.vivisectingmedia.framework.datastructures.tasks
{
	import com.vivisectingmedia.framework.controllers.interfaces.ITask;
	import com.vivisectingmedia.framework.controllers.interfaces.ITaskGroup;
	import com.vivisectingmedia.framework.datastructures.utils.PriorityQueue;
	
	import flash.events.EventDispatcher;

	/**
	 * The TaskGroup is a data structure that allows a set of tasks
	 * to be grouped together as a set.  The TaskGroup can then be
	 * added to the TaskController and all of the grouped task will
	 * be exectued first before the next task in the controller is
	 * processed.
	 * 
	 * <p>When an override is provided to the task controller, the
	 * task group acts as a parent type and the task group will
	 * remove all tasks if the provided override matches the group
	 * type.  The individual type of the task is ignored in this
	 * case.</p>
	 * 
	 * @author James Polanco
	 * 
	 */
	public class TaskGroup extends EventDispatcher implements ITaskGroup
	{
		/* PUBLIC PROPERTIES */
		
		/* PROTECTED PROPERTEIS */
		protected var taskQueue:PriorityQueue;
		
		/* PRIVATE PROPERTIES */
		private var __type:String;
		private var __groupOverrides:Array;
		private var __priority:int;
		private var __uid:Object;
		
		/**
		 * Constructor.  Sets the groups type and priority.
		 * 
		 * @param type The type of Task
		 * @param groupPriority
		 * 
		 */
		public function TaskGroup(type:String, priority:int = 5, uid:Object = null)
		{
			super(this);
			
			taskQueue = new PriorityQueue();
			__groupOverrides = new Array();
			__type = type;
			__priority = priority;
			__uid = uid
		}
		
		/**
		 * The current type of TaskGroup. The type defines how task
		 * overrides are applied when the group is in the queue.  
		 * If a task or task group overrides the matching type of 
		 * the group, the entire group is removed from the queue.
		 *  
		 * @return  The task type.
		 * 
		 */
		public function get type():String
		{
			return __type;
		}
		
		/**
		 * The priority value of the TaskGroup.  0 is the highest
		 * priority and uint.MAX_VALUE is the lowest priority.
		 *  
		 * @return 
		 * 
		 */
		public function get priority():uint
		{
			return __priority;
		}
		/**
		 * Unique id of the group instance.
		 * 
		 * @return id of the group
		 */
		public function get uid():Object {
			return __uid;
		}
		
		/**
		 * Determines if TaskGroup contains tasks or not.
		 *  
		 * @return True if tasks exist, false if not.
		 * 
		 */
		public function get hasTask():Boolean
		{
			return taskQueue.hasItems;
		}
		
		/**
		 * An array of types of tasks / task groups that this
		 * task group should override in the TaskController. When
		 * a task group is added to the controller, the controller
		 * uses the taskOverrides list to determine what tasks or
		 * other groups should be removed from the current queue.
		 *  
		 * @param value
		 * 
		 */
		public function set taskOverrides(value:Array):void
		{
			__groupOverrides = value;
		}
		
		public function get taskOverrides():Array
		{
			return __groupOverrides;
		}
		
		/**
		 * Adds a single task to the task group.  The added
		 * task is stored by its priority within the task
		 * group.
		 *  
		 * @param task
		 * 
		 */
		public function addTask(task:ITask):void
		{
			taskQueue.addItem(task, task.priority);
		}
		
		/**
		 * The tasks value is the active array of tasks
		 * within the task group.  When setting this value
		 * the tasks are ordered by priority within the
		 * task group, and the initial order of the provided
		 * array is ignored.
		 *  
		 * @param value
		 * 
		 */
		public function set tasks(value:Array):void
		{
			for each(var task:ITask in value)
			{
				taskQueue.addItem(task, task.priority);
			}
		}
		
		public function get tasks():Array
		{
			return taskQueue.items;
		}
		
		/**
		 * Removes all instances of a specific task from the group.
		 * When removed the task's cancel() method is called to
		 * allow listeners the ability to handle the removal.
		 * 
		 * @param task The task to remove.
		 * 
		 */
		public function removeTask(task:ITask):void
		{
			taskQueue.removeItem(task);
			task.cancel();
		}
		
		/**
		 * Removes all tasks from the group. When removed 
		 * the task's cancel() method is called to
		 * allow listeners the ability to handle the removal.
		 * 
		 */
		public function removeAllTasks():void
		{
			while(taskQueue.hasItems)
			{
				ITask(taskQueue.next()).cancel();
			}
		}
		
		/**
		 * Returns the next task in the group with the highest
		 * priority task first.  This method removes the task
		 * from the group.
		 *  
		 * @return The next task in the group.
		 * 
		 */
		public function next():ITask
		{
			return taskQueue.next();
		}
		
		public function getTaskIndex(task:ITask):int {
			// Loop through all tasks, if the same task is found
			// return index
			for(var i:uint=0;i<=tasks.length;i++) {
				if(tasks[i] == task) {
					return i; 
				}
			}
			// Return -1 if the task is NOT found
			return -1;
		}
		
	}
}