package com.plantstein.server;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.net.DatagramSocket;
import java.net.InetAddress;

/**
 * This class is the entry point of the server.
 * {@link SpringBootApplication} enables the Spring Boot auto configuration.
 */
@OpenAPIDefinition(
        info = @Info(
                title = "PlantStein API",
                description = "API documentation for the PlantStein app. " +
                        "This API is automatically generated from the server's code."
        )
)
@EnableScheduling
@SpringBootApplication
public class PlantSteinServer {
    public static void main(String[] args) {
        SpringApplication.run(PlantSteinServer.class, args);

        try (final DatagramSocket datagramSocket = new DatagramSocket()) {
            datagramSocket.connect(InetAddress.getByName("8.8.8.8"), 12345);
            System.out.println("Your local IP address is " + datagramSocket.getLocalAddress().getHostAddress());
            System.out.println("Docs: http://" + datagramSocket.getLocalAddress().getHostAddress() + ":8080/docs");
        } catch (Exception e) {
            System.out.println("Could not determine your local IP address.");
        }
    }


}
