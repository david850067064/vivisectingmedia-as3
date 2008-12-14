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
	import com.vivisectingmedia.framework.datastructures.tasks.TaskGroup;
	import com.vivisectingmedia.libtests.elements.tasks.TestTask;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority0;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority1;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority2;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority3;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority4;
	import com.vivisectingmedia.libtests.elements.tasks.TestTaskPriority5;
	
	import flexunit.framework.TestCase;

	public class TaskGroupTests extends TestCase
	{
		
		private const GROUP_TYPE:String = "Test_Group";
		
		public var taskGroup:TaskGroup
		
		public function TaskGroupTests(methodName:String=null)
		{
			super(methodName);
		}
		
		override public function setUp():void
		{
			// create a new controller
			taskGroup = new TaskGroup(GROUP_TYPE);
		}
		
		override public function tearDown():void
		{
			taskGroup = null;
		}
		
		// TEST METHODS
		/**
		 * Method tests that a type is saved via the constructor
		 */
		public function testType():void {
			// Test Group has same type as defined in constructor
			assertTrue("Group should have same type as defined in constructor", taskGroup.type == GROUP_TYPE);
		}
		
		public function testAddTasks():void {
			var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			var task2:TestTaskPriority2 = new TestTaskPriority2();
			var task3:TestTaskPriority3 = new TestTaskPriority3();
			var task4:TestTaskPriority4 = new TestTaskPriority4();
			var task5:TestTaskPriority5 = new TestTaskPriority5();
			
			// Add first item
			taskGroup.addTask(task4);
			// Verify one task can be added to the group
			assertTrue("Task should be first item", taskGroup.getTaskIndex(task4) == 0);
			// Verify only one task is in group
			assertTrue("One task should be in group", taskGroup.tasks.length == 1);
			// Verify a non added task returns -1
			assertTrue("Task should not be in Group", taskGroup.getTaskIndex(task5) == -1);
			
			// Add second item
			taskGroup.addTask(task5);
			// Verify priority 5 task is behind priority 4
			assertTrue("Task should be second item", taskGroup.getTaskIndex(task5) == 1);
			// Verify group has two tasks
			assertTrue("Two task should be in group", taskGroup.tasks.length == 2);
			
			// Add third item (task2, should be highest priority)
			taskGroup.addTask(task2);
			// Verify new task is first in priority
			assertTrue("Task should be first item", taskGroup.getTaskIndex(task2) == 0);			
			// Verify 3 items are in group
			assertTrue("Three tasks should be in group", taskGroup.tasks.length == 3);			
			// Verify other 2 tasks are in proper order (4,5)
			assertTrue("Task 4 should be second item in group", taskGroup.getTaskIndex(task4) == 1);
			assertTrue("Task 5 should be third item in group", taskGroup.getTaskIndex(task5) == 2);
			
			// Add fourth item (task3, should be second item)
			taskGroup.addTask(task3);
			// Verify 4 items are in group
			assertTrue("Four tasks should be in group", taskGroup.tasks.length == 4);			
			// Verify other 5 tasks are in proper order (2,3,4,5)
			assertTrue("Task 2 should be first item in group", taskGroup.getTaskIndex(task2) == 0);
			assertTrue("Task 3 should be second item in group", taskGroup.getTaskIndex(task3) == 1);
			assertTrue("Task 4 should be third item in group", taskGroup.getTaskIndex(task4) == 2);
			assertTrue("Task 5 should be fourth item in group", taskGroup.getTaskIndex(task5) == 3);
			
			// Add fifth item (task0, should be first item)
			taskGroup.addTask(task0);
			// Verify 5 items are in group
			assertTrue("Five tasks should be in group", taskGroup.tasks.length == 5);			
			// Verify proper order (0,2,3,4,5)
			assertTrue("Task 0 should be first item in group", taskGroup.getTaskIndex(task0) == 0);
			assertTrue("Task 2 should be second item in group", taskGroup.getTaskIndex(task2) == 1);
			assertTrue("Task 3 should be third item in group", taskGroup.getTaskIndex(task3) == 2);
			assertTrue("Task 4 should be fourth item in group", taskGroup.getTaskIndex(task4) == 3);
			assertTrue("Task 5 should be fifth item in group", taskGroup.getTaskIndex(task5) == 4);
			
			
			// Add sixth item (task1, should be second item)
			taskGroup.addTask(task1);
			// Verify 6 items are in group
			assertTrue("Six tasks should be in group", taskGroup.tasks.length == 6);			
			// Verify proper order (0,12,3,4,5)
			assertTrue("Task 0 should be first item in group", taskGroup.getTaskIndex(task0) == 0);
			assertTrue("Task 1 should be secon item in group", taskGroup.getTaskIndex(task1) == 1);
			assertTrue("Task 2 should be third item in group", taskGroup.getTaskIndex(task2) == 2);
			assertTrue("Task 3 should be fourth item in group", taskGroup.getTaskIndex(task3) == 3);
			assertTrue("Task 4 should be fifth item in group", taskGroup.getTaskIndex(task4) == 4);
			assertTrue("Task 5 should be sixth item in group", taskGroup.getTaskIndex(task5) == 5);
		}
		/**
		 * Test verifies that TaskGroup indicates whether it has a task or not
		 */
		public function testHasTask():void {
			var task:TestTask = new TestTask();
			
			taskGroup.addTask(task);
			
			assertTrue("Task Group should have task", taskGroup.hasTask);
			
			taskGroup.removeTask(task);
			
			assertFalse("Task Group should NOT have task", taskGroup.hasTask);
		}
		
		/**
		 * Test verifies removing a task works correctly
		 */
		 public function testRemoveTask():void {
		 	var task:TestTaskPriority0 = new TestTaskPriority0();
			
			// Add one task
			taskGroup.addTask(task);
			// Verify task is added
			assertTrue("Task should be added", taskGroup.getTaskIndex(task) >= 0);
			// Remove task
			taskGroup.removeTask(task);
			// Verify task is removed			
			assertFalse("Task should be removed", taskGroup.getTaskIndex(task) >= 0);
		 }
		 
		 /**
		 * Test verifies removing multiple tasks works as expected.
		 * These test do not work with TestContoller
		 */
		 public function testRemoveTasks():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			var task2:TestTaskPriority2 = new TestTaskPriority2();
			var task3:TestTaskPriority3 = new TestTaskPriority3();
			
			// Add three tasks
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			taskGroup.addTask(task2);
			
			// Remove Middle Task
			taskGroup.removeTask(task1);
			
			// Verify 2 tasks remain and are expected two
			assertTrue("Two tasks should be in group", taskGroup.tasks.length == 2);
			assertTrue("Task 0 should still be in group", taskGroup.getTaskIndex(task0) >= 0);
			assertTrue("Task 2 should still be in group", taskGroup.getTaskIndex(task2) >= 0);
			// Verify task removed is not there
			assertFalse("Task 1 should not be in group", taskGroup.getTaskIndex(task1) >= 0);
			
			// Remove last two
			taskGroup.removeTask(task0);
			taskGroup.removeTask(task2);
			// Verify no tasks remain
			assertTrue("No tasks should be in group", taskGroup.tasks.length == 0);
			
			// Add three tasks, again
			taskGroup.addTask(task0);
			taskGroup.addTask(task1);
			taskGroup.addTask(task2);
			
			// Verify three are added
			assertTrue("Three tasks should be in group", taskGroup.tasks.length == 3);
			// Remove all items
			taskGroup.removeAllTasks();			
			// Verify three are removed
			assertTrue("No tasks should be in group", taskGroup.tasks.length == 0);
		 }
		 /**
		 * Test verifies groups next method functionality
		 */
		 public function testNext():void {
		 	var task0:TestTaskPriority0 = new TestTaskPriority0();
			var task1:TestTaskPriority1 = new TestTaskPriority1();
			var task2:TestTaskPriority2 = new TestTaskPriority2();
			var task3:TestTaskPriority3 = new TestTaskPriority3();
			
			// Add three tasks
			taskGroup.addTask(task0);
			taskGroup.addTask(task2);
			taskGroup.addTask(task1);
			
			assertTrue("Next should return task0", taskGroup.next() == task0);
			assertTrue("Next should return task1", taskGroup.next() == task1);
			assertTrue("Next should return task2", taskGroup.next() == task2);			
		 }
		 
	}
}