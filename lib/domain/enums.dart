/// Enums shared by the database and the domain logic.
///
/// Stored in the DB by name (drift `textEnum`), so renaming a value is a
/// schema migration. Only add new values.
library;

enum Gender { female, male }

enum AppLanguage { he, es, en }

enum RoutineType { morning, noon, evening }

enum TaskPack { core, jewish, custom }

enum StarReason { taskDone, redemption }
