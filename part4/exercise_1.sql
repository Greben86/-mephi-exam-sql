/*
Найти всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1), включая их подчиненных и подчиненных подчиненных. Для каждого сотрудника вывести следующую информацию:

EmployeeID: идентификатор сотрудника.
Имя сотрудника.
ManagerID: Идентификатор менеджера.
Название отдела, к которому он принадлежит.
Название роли, которую он занимает.
Название проектов, к которым он относится (если есть, конкатенированные в одном столбце через запятую).
Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце через запятую).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
Требования:

Рекурсивно извлечь всех подчиненных сотрудников Ивана Иванова и их подчиненных.
Для каждого сотрудника отобразить информацию из всех таблиц.
Результаты должны быть отсортированы по имени сотрудника.
Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.
 */

-- Рекурсивный запрос для выборки всех подчиненных
WITH RECURSIVE Subquery AS (
    -- Находим всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1)
    SELECT e1.EmployeeID, e1.Name, e1.ManagerID, e1.DepartmentID, e1.RoleID
    FROM Employees e1
    WHERE e1.ManagerID = 1  
    
    UNION
    
    -- Находим всех подчиненных подчиненных
    SELECT e2.EmployeeID, e2.Name, e2.ManagerID, e2.DepartmentID, e2.RoleID
    FROM Employees e2
        INNER JOIN Subquery s ON (e2.ManagerID = s.EmployeeID)
)

SELECT 
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    d.DepartmentName AS Department, 
    r.RoleName AS Role,              
    -- Выводим все проекты сотрудника, или NULL если их нет
    COALESCE((SELECT GROUP_CONCAT(p.ProjectName, ', ') FROM Projects p WHERE p.DepartmentID = s.DepartmentID), 'NULL') AS ProjectNames,  
    -- Выводим все задачи сотрудника, или NULL если их нет
    COALESCE((SELECT GROUP_CONCAT(t.TaskName, ', ') FROM Tasks t WHERE t.AssignedTo = s.EmployeeID), 'NULL') AS TaskNames                               
FROM Subquery s
    LEFT JOIN Departments d ON (s.DepartmentID = d.DepartmentID)
    LEFT JOIN Roles r ON (s.RoleID = r.RoleID)
ORDER BY s.Name;
