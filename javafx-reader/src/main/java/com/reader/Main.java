package com.reader;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) {
        // 创建一个简单的界面来测试
        Label label = new Label("JavaFX阅读器启动成功！\n双排阅读功能即将实现");
        label.setStyle("-fx-font-size: 16px; -fx-padding: 20px;");

        StackPane root = new StackPane();
        root.getChildren().add(label);

        Scene scene = new Scene(root, 600, 400);
        primaryStage.setTitle("JavaFX阅读器");
        primaryStage.setScene(scene);
        primaryStage.show();
    }

    public static void main(String[] args) {
        // 简单的启动代码
        launch(args);
    }
}