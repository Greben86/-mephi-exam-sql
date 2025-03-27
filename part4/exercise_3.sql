/*
Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0). Для каждого такого сотрудника вывести следующую информацию:

EmployeeID: идентификатор сотрудника.
Имя сотрудника.
Идентификатор менеджера.
Название отдела, к которому он принадлежит.
Название роли, которую он занимает.
Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
 */

-- Рекурсивный запрос для выборки менеджера и всех его подчиненных 
WITH RECURSIVE TreeEmployes AS (
    -- Находим мененджера
    SELECT e0.EmployeeID, e0.Name, e0.ManagerID, e0.DepartmentID, e0.RoleID, e0.EmployeeID AS bossID
    FROM Employees e0
        INNER JOIN Roles r ON (e0.RoleID = r.RoleID AND r.RoleName = 'Менеджер')
    WHERE e0.EmployeeID IN (SELECT ManagerID FROM Employees)
    
    UNION
    
    -- Находим всех подчиненных менеджера
    SELECT e1.EmployeeID, e1.Name, e1.ManagerID, e1.DepartmentID, e1.RoleID, sub.bossID
    FROM Employees e1
        INNER JOIN TreeEmployes sub ON (e1.ManagerID = sub.EmployeeID)
)

SELECT 
    e.EmployeeID,
    e.Name AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    -- Выводим все проекты сотрудника, или NULL если их нет
    COALESCE((SELECT GROUP_CONCAT(p.ProjectName, ', ') FROM Projects p WHERE p.DepartmentID = e.DepartmentID), 'NULL') AS ProjectNames,
    -- Выводим все задачи сотрудника, или NULL если их нет
    COALESCE((SELECT GROUP_CONCAT(t.TaskName, ', ') FROM Tasks t WHERE t.AssignedTo = e.EmployeeID), 'NULL') AS TaskNames,
    -- Выводим количество подчиненных
    (SELECT COUNT(*) FROM TreeEmployes t WHERE t.bossID = e.EmployeeID AND t.EmployeeID <> e.EmployeeID) AS TotalSubordinates
FROM Employees e
    INNER JOIN TreeEmployes m ON (m.bossID = e.EmployeeID AND m.EmployeeID = e.EmployeeID)
    INNER JOIN Departments d ON (e.DepartmentID = d.DepartmentID)
    INNER JOIN Roles r ON (e.RoleID = r.RoleID)
ORDER BY e.Name;
