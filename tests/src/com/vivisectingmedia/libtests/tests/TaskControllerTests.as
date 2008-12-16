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
	import com.vivisectingmedia.framework.controllers.interfaces.ITask;
	import com.vivisectingmedia.framework.datastructures.tasks.TaskGroup;
	import com.vivisectingmedia.libtests.elements.tasks.TestTask;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority0;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority1;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority2;
	
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
		
		/**
		 * Verify that adding a task group will execute on item
		 */
		 public function testAddTaskGroupWithOneTask():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	
			task1.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
			taskGroup.addTask(task1);
			controller.addTaskGroup(taskGroup);
		 }
		 
		 /**
		 * Verify that adding a task group will execute two items
		 */
		 public function testAddTaskGroupWithTwoTask():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			// Listen to second task, verify it started
			task1.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
			
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);

			controller.addTaskGroup(taskGroup);
			task0.triggerComplete();
		 }
		 
		 public function testTaskGroupRemoveTask():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			// Listen to task, verify it was canceled after removed from group
			task0.addEventListener(TaskEvent.TASK_CANCEL, addAsync(handleTaskCanceled,500),false, 0,true);
			// Add task to group
			taskGroup.addTask(task0);
			// Add group to controller
			controller.addTaskGroup(taskGroup);
			// Remove task from group
			taskGroup.removeTask(task0);
			// Verify task is removed from group
			assertFalse("Task should be removed from group", taskGroup.getTaskIndex(task0) >= 0);
		 }
		 
		 /**
		 * Test verifies that removing an item from a group will still fire next item in queue
		 */ 
		 public function testTaskGroupRemoveTasks():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP");
		 	
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2:TestTaskPriority2 = new TestTaskPriority2();
		 			 	
			// Listen to task, verify it was canceled after removed from group
			task2.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
			// Add task to group
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			taskGroup.addTask(task2);			
			// Add group to controller
			controller.addTaskGroup(taskGroup);
			// Remove Second item
			taskGroup.removeTask(task1);
			// Mark first task as complete, third task should start
			task0.triggerComplete();
		 }
		 /**
		 * Test verifies TaskController's ability to handle Canceled Tasks
		 */
		 public function testTaskCancel():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2:TestTaskPriority2 = new TestTaskPriority2();
		 	
		 	// Verify third task starts,when second is canceled and first is completed
		 	task2.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
		 	
		 	// Add Three tasks to controller
		 	controller.addTask(task0);
		 	controller.addTask(task1);
		 	controller.addTask(task2);
		 	// Cancel second task in queue
		 	task1.cancel();
		 	// Fake complete
		 	task0.triggerComplete();
		 }
		 
		 /**
		 * Test verifies TaskController's ability to handle Canceled Tasks
		 */
		 public function testTaskGroupCancel():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP",0);
		 	
		 	var task0ToGroup:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1ToGroup:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2NotInGroup:TestTaskPriority2 = new TestTaskPriority2();
		 	
		 	// Add Two tasks to group
		 	taskGroup.addTask(task0ToGroup);
		 	taskGroup.addTask(task1ToGroup);
		 	
		 	// Add Group controller
		 	controller.addTaskGroup(taskGroup);
		 	// Add task to controller
		 	controller.addTask(task2NotInGroup);
		 	
		 	// Verify third task starts,when group is canceled
		 	task2NotInGroup.addEventListener(TaskEvent.TASK_START, addAsync(handleTaskStart,500),false, 0,true);
		 	
		 	// Cancel group
		 	taskGroup.cancel();
		 }
		 public function testGroupInQueue():void {
		 	var taskGroup:TaskGroup = new TaskGroup("TASKGROUP",0);
		 	
		 	var task0ToGroup:TestTaskPriority0 = new TestTaskPriority0();
		 	var task1ToGroup:TestTaskPriority1 = new TestTaskPriority1();
		 	var task2NotInGroup:TestTaskPriority2 = new TestTaskPriority2();
		 	
		 	// Add Two tasks to group
		 	taskGroup.addTask(task0ToGroup);
		 	taskGroup.addTask(task1ToGroup);
		 	
		 	// Verify group is marked as InQueue
		 	taskGroup.addEventListener(TaskEvent.TASK_QUEUED, addAsync(handleTaskQueued,500),false, 0,true);
		 	// Add Group controller
		 	controller.addTaskGroup(taskGroup);
		 }
		 
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the same type and Id
		 */
		 public function testTaskGroupOverrideWithSameTypesSameId():void {
		 	
		 }
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the same type and differnt Ids
		 */
		 public function testTaskGroupOverrideWithDifferentSameDifferentId():void {
		 	
		 }
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the different type and s Ids
		 */
		 public function testTaskGroupOverrideWithDifferentTypesSameId():void {
		 	
		 }
		 /**
		 * Test verifies the override capabilities of a Group
		 * when both groups are of the different type and differnt Ids
		 */
		 public function testTaskGroupOverrideWithDifferentTypesDifferentId():void {
		 	
		 }
		// test specific handlers
		// generic handlers for task event
		protected function handleTaskQueued(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to queued.", currentTask.phase == TaskEvent.TASK_QUEUED);
		}
		
		protected function handleTaskStart(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to start.", currentTask.phase == TaskEvent.TASK_START);
		}
		
		protected function handleTaskInWaiting(event:TaskEvent):void
		{
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to in waiting.", currentTask.phase == TaskEvent.TASK_WAITING_FOR_READY);
		}
		protected function handleTaskCanceled(event:TaskEvent):void {
			// verify the current phase is set
			var currentTask:ITask = ITask(event.currentTarget);
			assertTrue("The task's phase was not set to cancel.", currentTask.phase == TaskEvent.TASK_CANCEL);
		}
	}
}