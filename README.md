# **Developer Reflection**

## **1. What part was hardest and why?**

Honestly, there were some parts that required extra focus and effort from me, 
but in the end, I was able to overcome them. One of the most challenging 
aspects was aligning the requirements with my database, which led me to 
create some tables and modify others to meet the specifications. Additionally, 
there were occasional errors due to the precision and strict conditions of the task. 
Overall, it was a valuable experience that allowed me to test and apply 
what I’ve learned over the past period.

## **2. Which concept helped them think like a backend dev?**

Stored Procedures and Functions were the concepts that helped me think like a backend developer.
and that because they allowed me to encapsulate complex logic and operations within the database,
into reusable components. This not only improved the efficiency of my code but also made 
it easier to maintain and debug.

## **3. How would they test this if it were a live web app?**

If this were a live web application, testing would involve both backend database operations 
and frontend user interactions. The goal would be to ensure that all functionality works 
smoothly and that data integrity is maintained. Here’s how testing might be approached:

**1. Functional Testing**

They would verify that each feature works as expected:
  - User registration/login (if applicable).
  - Searching and viewing books.
  - Borrowing and returning books.
  - Adding reviews.
  - Admin operations like adding/removing books or members.
	
Test cases would include:
  - A member borrows a book and the book availability updates.
  - A member submits a review and it's correctly saved and linked.
  - An admin deletes a member and cascading rules clean up related records.

**2. Database Integrity Tests**

- Ensure foreign key constraints are enforced.
- Test cascading updates/deletes by removing members or books.
- Validate that no orphan records are left in linking tables like Member_books.

**3. UI/UX Testing**

- Verify that the frontend accurately reflects backend changes 
(e.g., a book marked as "loaned out" no longer appears as available).
- Confirm proper form validation and error messages for invalid input 
(e.g., trying to borrow a book that is already loaned out).

**4. Performance Testing**

- Simulate multiple users interacting with the system at once (e.g., concurrent book loans).
- Ensure the system remains responsive and doesn’t crash under load.

**5. Security Testing**

- Ensure proper access control: only authorized users 
(e.g., admins) can perform sensitive operations.
- Protect against SQL injection by validating and sanitizing inputs.
