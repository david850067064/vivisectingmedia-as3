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
 package com.vivisectingmedia.libtests.tests
{
	import com.vivisectingmedia.framework.controllers.TaskController;
	import com.vivisectingmedia.framework.controllers.events.TaskEvent;
	import com.vivisectingmedia.libtests.elements.tasks.TestTask;
	
	import flexunit.framework.TestCase;

	public class TaskControllerTests extends TestCase
	{
		public var controller:TaskController;
		
		public function TaskControllerTests(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			// create a new controller
			controller = new TaskController();
		}
		
		override public function tearDown():void
		{
			controller = null;
		}
		
		/**
		 * Verify that adding a task that is ready to the controller 
		 * successfully adds the task, calls next() and the task is started() 
		 * 
		 */		
		public function testAddTaskReady():void
		{
			var task:TestTask = new TestTask();
			task.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart, 100), false, 0, true);
			controller.addTask(task);
			
		}
		
		/**
		 * Verify that when an item is added but not started, the 
		 * queued state is set and defined .
		 * 
		 */		
		public function testAddTaskTestQueued():void
		{
			var task:TestTask = new TestTask();
			task.addEventListener(TaskEvent.TASK_QUEUED, addAsync(handleTaskQueued, 100), false, 0, true);
			
			var blockerTask:TestTask = new TestTask();
			controller.addTask(blockerTask);
			controller.addTask(task);
		}
		
		/**
		 * Verify that adding a task that is not ready is added to 
		 * the controller, next() is called but the task is not run 
		 * yet is put in not ready queue.
		 * 
		 */
		public function testAddTaskNotReady():void
		{
			var task:TestTask = new TestTask(TestTask.NOT_READY);
			task.addEventListener(TaskEvent.TASK_WAITING_FOR_READY, addAsync(handleTaskInWaiting, 100), false, 0, true);
			controller.addTask(task);
		}
		
		/**
		 * Verify that adding a task that is not ready is put into the 
		 * task list then change the task to ready state and verify 
		 * it is started.
		 * 
		 */		
		public function testAddTaskChangeReady():void
		{
			var task:TestTask = new TestTask(TestTask.NOT_READY);
			task.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart, 500), false, 0, true);
			controller.addTask(task);
			task.triggerReady();
		}
		
		// test specific handlers
				
		
		// generic handlers for task event
		protected function handleTaskQueued(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:TestTask = TestTask(event.currentTarget);
			assertTrue("The task's phase was not set to queued.", currentTask.phase == TaskEvent.TASK_QUEUED);
		}
		
		protected function handleTaskStart(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:TestTask = TestTask(event.currentTarget);
			assertTrue("The task's phase was not set to start.", currentTask.phase == TaskEvent.TASK_START);
		}
		
		protected function handleTaskInWaiting(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:TestTask = TestTask(event.currentTarget);
			assertTrue("The task's phase was not set to in waiting.", currentTask.phase == TaskEvent.TASK_WAITING_FOR_READY);
		}
	}
}