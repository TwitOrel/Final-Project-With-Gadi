# השתמש בבסיס של OpenJDK
FROM openjdk:17

# הגדר תיקיית עבודה בתוך הקונטיינר
WORKDIR /app

# העתק את קובץ ה-Java לקונטיינר
COPY WaterMark.java .

# קומפילציה של הקובץ
RUN javac WaterMark.java

# הפעלת הקוד עם נתיב ברירת מחדל (אפשר לשנות)
ENTRYPOINT ["java", "WaterMark"]