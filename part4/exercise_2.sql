/*
Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных. Для каждого сотрудника вывести следующую информацию:

EmployeeID: идентификатор сотрудника.
Имя сотрудника.
Идентификатор менеджера.
Название отдела, к которому он принадлежит.
Название роли, которую он занимает.
Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
Общее количество задач, назначенных этому сотруднику.
Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
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
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    -- Выводим все проекты сотрудника, или NULL если их нет
    COALESCE((SELECT GROUP_CONCAT(p.ProjectName, ', ') FROM Projects p WHERE p.DepartmentID = s.DepartmentID), 'NULL') AS ProjectNames,
    -- Выводим все задачи сотрудника, или NULL если их нет
    COALESCE((SELECT GROUP_CONCAT(t.TaskName, ', ') FROM Tasks t WHERE t.AssignedTo = s.EmployeeID), 'NULL') AS TaskNames,
    -- Выводим количество задач сотрудника
    (SELECT COUNT(*) FROM Tasks t WHERE t.AssignedTo = s.EmployeeID) AS TaskCount,
    -- Выводим количество подчиненных
    (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = s.EmployeeID) AS SubEmployesCount
FROM Subquery s
    LEFT JOIN Departments d ON (s.DepartmentID = d.DepartmentID)
    LEFT JOIN Roles r ON (s.RoleID = r.RoleID)
ORDER BY s.Name;
