USE Gringotts

SELECT DepositGroup, SUM(DepositAmount)
FROM WizzardDeposits
GROUP BY DepositGroup