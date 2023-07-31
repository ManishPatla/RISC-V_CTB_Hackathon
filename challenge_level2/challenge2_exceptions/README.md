# Challenge Level 2:

## Challenge 2 : Exceptions

**This is an AAPG  generation test setup*
Here with expereince from the previous challenge ,we create a AAPG config file to generate  a test with 10 illegal exceptions with the correct handler code 

### To generate a test with 10 illegal exceptions and the correct handler code using AAPG, we will need to modify the AAPG configuration file (rv32i.yaml) accordingly. Specifically, we need to define the handler code for each illegal exception and ensure that the test runs successfully on Spike.

**i)Yaml File Creation:**

Here the The YAML file serves as a configuration file that provides instructions to AAPG on how to generate a random RISC-V program.
The YAML file was created manually to configure the behavior of the Automated Assembly Program Generator (AAPG) tool.
It contains various sections, each specifying different aspects of the program generation process. The sections and their respective options are defined with the help of keys and values in the YAML format.

The configuration file is created using a text editor, and each section is organized hierarchically using indentation. The values specified in the YAML file influence the frequency and distribution of instructions, privilege modes, data access sections, CSR (Control and Status Register) sections, recursion options, self-checking settings, exception generation, cache thrashing, and more.

**ii) Exceptions Generation Explanation:**

In the YAML file, there is a section called exception-generation, which is responsible for controlling the generation of exceptions in the random RISC-V program. Each exception cause is represented by a key (e.g., ecause00, ecause01, etc.) and its corresponding value determines the number of exceptions generated for that particular cause.

Here's an explanation of how exceptions are generated based on the exception-generation section:

For ecause00, ecause01, and ecause02, the value is set to 10. This means that AAPG will generate 10 exceptions for each of these exception causes (10 exceptions for ecause00, 10 for ecause01, and 10 for ecause02). These causes are considered as illegal instruction exceptions.

For ecause03 to ecause14, the value is set to 0. This means that AAPG will not generate any exceptions for these causes. They are effectively disabled in the generated random RISC-V program.

By setting the values accordingly in the exception-generation section, you can control which exceptions are generated in the random program. In this case, the YAML file has been set up to generate 10 illegal instruction exceptions (ecause00, ecause01, and ecause02) and disable the other exceptions (ecause03 to ecause14).

Overall, the exception-generation section allows us to tailor the exception generation behavior according to your testing or verification requirements.

**Screenshot of bug fixed:*

[![Screenshot-263.png](https://i.postimg.cc/3N7SRvvn/Screenshot-263.png)](https://postimg.cc/ZB7Fs0jd)

