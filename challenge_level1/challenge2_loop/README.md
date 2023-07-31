# Challenge Level 1 :

## Loop:

**We have an test file which runs without exiting the spike here the test performs addition operation and self checks for 3 set of test cases*

**Bug Explanation:**

Analysisng Test.S file here :

<img width="245" alt="image" src="https://github.com/vyomasystems-lab/riscv-ctb-challenge-ManishPatla/assets/109287423/1857aeaa-42b2-4a10-8f45-cae55dae9f5b">


Here the test file is designed to perform addition operations and check the results against expected values. However, there seems to be an issue with the comparison and failure detection in the loop.


**Bug Fix Explanation:**

To fix the test, we need to adjust the comparison and failure detection logic in the loop. The current code uses beq instruction to check if t3 (the expected sum) is equal to t4 (the computed sum). However, beq only branches when the two operands are equal. In this case, we need to branch when they are not equal, indicating a failure.

Here's the fixed code for the loop:

[![Screenshot-2023-07-31-175248.png](https://i.postimg.cc/dQhr8Q84/Screenshot-2023-07-31-175248.png)](https://postimg.cc/fkhVsNq9)

#The changes made here:

We used the bne (branch not equal) instruction to check if t3 is not equal to t4.
If the condition is true (the expected sum is not equal to the computed sum), it jumps to the fail label.
We also introduced a test case counter using t5 (initialized to 3) to keep track of the number of remaining test cases.
After each iteration, we decrement the test case counter using sub t5, t5, 1.
If the test case counter t5 is not zero (bnez t5, loop), we continue to the next test case.
The loop now iterates through all the test cases and performs the addition operation correctly while checking for failures. If there's any mismatch between the expected and computed sums, the test will jump to the fail label.

**Screenshot of the Bug Fix:*

[![Screenshot-2023-07-31-170552.png](https://i.postimg.cc/ZKRJwBWG/Screenshot-2023-07-31-170552.png)](https://postimg.cc/Jtfwnhcx)

