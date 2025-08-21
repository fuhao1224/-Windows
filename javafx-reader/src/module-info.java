module com.reader {
    requires javafx.controls;
    requires javafx.fxml;
    requires javafx.web;

    opens com.reader to javafx.fxml;
    exports com.reader;
}