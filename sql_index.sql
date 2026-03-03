-- Indici per Subscriptions
CREATE INDEX idx_subscriptions_badgecode ON Subscriptions(badgeCode, gymId);
CREATE INDEX idx_subscriptions_userid ON Subscriptions(userId, gymId);
CREATE INDEX idx_subscriptions_courseid ON Subscriptions(courseId, gymId);

-- Indici per Users
CREATE INDEX idx_users_gymid_archived ON Users(gymId, archived);
CREATE INDEX idx_users_name_surname ON Users(name(100), surname(100));
CREATE INDEX idx_users_email ON Users(email(100), gymId);
CREATE INDEX idx_users_creation ON Users(creation, gymId);
CREATE INDEX idx_users_birthday ON Users(birthday, gymId);
CREATE INDEX idx_users_flagged ON Users(flagged, gymId);
CREATE INDEX idx_users_forceblock ON Users(forceBlock, gymId);

-- Indici per Shifts
CREATE INDEX idx_shifts_course_day ON Shifts(courseId, dayOfWeek, gymId);
CREATE INDEX idx_shifts_bookable ON Shifts(bookable, gymId);

-- Indici per Entries
CREATE INDEX idx_entries_user_date ON Entries(userId, date, gymId);
CREATE INDEX idx_entries_date ON Entries(date, gymId);
CREATE INDEX idx_entries_gymid ON Entries(gymId, date);
CREATE INDEX idx_entries_subscription ON Entries(subscriptionId, gymId);

-- Indici per Courses
CREATE INDEX idx_courses_gymid ON Courses(gymId);

-- Indici per CoursePlans
CREATE INDEX idx_courseplans_gymid ON CoursePlans(gymId);
CREATE INDEX idx_courseplans_courseid ON CoursePlans(courseId, gymId);
