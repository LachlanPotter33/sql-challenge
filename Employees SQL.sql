--add csv's into tables - make primary keys 

set datestyle TO 'ISO,DMY';

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" integer   NOT NULL,
    "emp_title" varchar   NOT NULL,
    "birth_date" varchar   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "sex" varchar   NOT NULL,
    "hire_date" varchar   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY ("emp_no")
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR    NOT NULL,
    "dept_name" VARCHAR     NOT NULL,
    CONSTRAINT "pk_dept_managers" PRIMARY KEY (
        "dept_no"
     )
);

SET datestyle TO 'ISO, MDY';

ALTER TABLE employees
    ALTER COLUMN hire_date TYPE DATE USING hire_date::DATE;
	
ALTER TABLE employees
    ALTER COLUMN birth_date TYPE DATE USING birth_date::DATE;

CREATE TABLE "salaries" (
    "emp_no" integer   NOT NULL,
    "salary" integer   NOT NULL   
);

CREATE TABLE "dept_emp" (
    "emp_no" integer   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR    NOT NULL,
    "emp_no" integer   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

-- List the employee number, last name, first name, sex, and salary of each employee.
	--get emp_no, last_name, first_name, sex from employees table 
		-- get salary from Salaries table 
			--common- emp_no
SELECT 
	employees.emp_no, 
	employees.last_name, 
	employees.first_name, 
	employees.sex, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- List the first name, last name, and hire date for the employees who were hired in 1986.
	-- all from salaries 
		--use where to find date 
select 
	employees.last_name, 
	employees.first_name,
	employees.hire_date
from employees
where extract(year from employees.hire_date) = 1986;

-- List the manager of each department along with their department number, department name, employee number, last name, and first name.
	-- get dept_no, Dept Name from departments
	 	-- get emp_no, last and first name from employees
			-- common join emp_no for employyee and dept manager then dept manager with departments 
select 
	departments.dept_no,
	departments.dept_name,
	employees.emp_no,
	employees.last_name,
	employees.first_name
from dept_manager
join employees
on dept_manager.emp_no = employees.emp_no
join departments
on dept_manager.dept_no = departments.dept_no;

-- List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
		-- dep manager, department and employees 
select 
	departments.dept_no,
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
from dept_manager
join employees
on dept_manager.emp_no = employees.emp_no
join departments
on dept_manager.dept_no = departments.dept_no;

-- List the first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
select 
	employees.last_name,
	employees.first_name,
	employees.sex
from employees
where employees.first_name = 'Hercules' and employees.last_name like 'B%'
;

-- List each employee in the Sales department, including their employee number, last name, and first name.
	--common link emp no and dept no 
select 
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
from employees
join dept_emp
on employees.emp_no = dept_emp.emp_no
join departments 
on dept_emp.dept_no = departments.dept_no
where departments.dept_name = 'Sales';

-- List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
		-- common emp no and dept no 

select 
	employees.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
from employees
join dept_emp
on employees.emp_no = dept_emp.emp_no
join departments
on dept_emp.dept_no = departments.dept_no
where departments.dept_name = 'Sales' or departments.dept_name ='Development';

-- List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT last_name, COUNT(last_name) as frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;