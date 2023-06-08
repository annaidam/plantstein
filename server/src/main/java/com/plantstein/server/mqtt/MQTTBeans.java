//Based on:
//https://www.youtube.com/watch?v=HHKrKwI--Yw

package com.plantstein.server.mqtt;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.plantstein.server.AppConfig;
import com.plantstein.server.dto.IncomingTimeSeriesDTO;
import com.plantstein.server.exception.NotFoundException;
import com.plantstein.server.model.Moisture;
import com.plantstein.server.model.Plant;
import com.plantstein.server.model.PlantTimeSeries;
import com.plantstein.server.model.RoomTimeSeries;
import com.plantstein.server.repository.PlantRepository;
import com.plantstein.server.repository.PlantTimeSeriesRepository;
import com.plantstein.server.repository.RoomRepository;
import com.plantstein.server.repository.RoomTimeSeriesRepository;
import com.plantstein.server.util.Utils;
import lombok.RequiredArgsConstructor;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.core.MessageProducer;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.integration.mqtt.support.DefaultPahoMessageConverter;
import org.springframework.integration.mqtt.support.MqttHeaders;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;

import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.Arrays;


@Configuration
@RequiredArgsConstructor
public class MQTTBeans {
    private static final Logger LOGGER = LoggerFactory.getLogger(MQTTBeans.class);
    private final ObjectMapper objectMapper;
    private final RoomRepository roomRepository;
    private final PlantRepository plantRepository;
    private final RoomTimeSeriesRepository roomTimeSeriesRepository;
    private final PlantTimeSeriesRepository plantTimeSeriesRepository;

    public MqttPahoClientFactory mqttClientFactory() {
        DefaultMqttPahoClientFactory factory = new DefaultMqttPahoClientFactory();
        MqttConnectOptions options = new MqttConnectOptions();

        String[] uri = new String[]{"tcp://localhost:1883"};
        options.setServerURIs(uri);
        options.setCleanSession(true);
        options.setAutomaticReconnect(true);

        factory.setConnectionOptions(options);
        return factory;
    }

    @Bean
    public MessageChannel mqttInputChannel() {
        return new DirectChannel();
    }

    @Bean
    public MessageProducer inBound() {
        MqttPahoMessageDrivenChannelAdapter adapter = new MqttPahoMessageDrivenChannelAdapter("serverIn", mqttClientFactory(), "#");
        adapter.setCompletionTimeout(5000);
        adapter.setConverter(new DefaultPahoMessageConverter());
        adapter.setQos(2);
        adapter.setOutputChannel(mqttInputChannel());
        return adapter;
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttInputChannel")
    public MessageHandler handler() {
        return message -> {
            String topic = message.getHeaders().get(MqttHeaders.RECEIVED_TOPIC).toString();
            String topicType = topic.split("/")[0];
            String plantId = topic.contains("/") ? topic.split("/")[1] : null;


            if (AppConfig.Topic.TIMESERIES.toString().equals(topicType)) {
                try {
                    IncomingTimeSeriesDTO timeseries = objectMapper.readValue(message.getPayload().toString(), IncomingTimeSeriesDTO.class);
                    System.out.println("Timeseries: " + timeseries.toString());
                    DecimalFormat decimalFormat = new DecimalFormat("#.00");

                    Plant plant = plantRepository.findById(Long.parseLong(plantId)).orElseThrow(() -> new NotFoundException("Plant " + plantId + " not found"));
                    Timestamp timestamp = new Timestamp(System.currentTimeMillis());

                    roomTimeSeriesRepository.save(
                            RoomTimeSeries.builder()
                                    .room(plant.getRoom())
                                    .timestamp(timestamp)
                                    .temperature(Utils.roundToDecimalPlaces(timeseries.getTemperature(), 2))
                                    .humidity(Utils.roundToDecimalPlaces(timeseries.getHumidity(), 2))
                                    .brightness(timeseries.getBrightness())
                                    .build()
                    );
                    plantTimeSeriesRepository.save(
                            PlantTimeSeries.builder()
                                    .plant(plant)
                                    .timestamp(timestamp)
                                    .moisture(Moisture.fromString(timeseries.getMoisture()))
                                    .build()
                    );
                } catch (JsonProcessingException e) {
                    LOGGER.error("Error parsing timeseries" + message.getPayload().toString());
                } catch (NotFoundException e) {
                    LOGGER.error("Received timeseries, but that plant could not be found, " + message.getPayload().toString());
                }
            } else if (!Arrays.stream(AppConfig.Topic.values()).map(AppConfig.Topic::toString).toList()
                    .contains(topicType))
                System.out.println("Incoming mqtt message on unknown topic: " + topic);
        };
    }

    @Bean
    public MessageChannel mqttOutBoundChannel() {
        return new DirectChannel();
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttOutBoundChannel")
    public MessageHandler mqttOutBound() {
        MqttPahoMessageHandler messageHandler = new MqttPahoMessageHandler("serverOut", mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic("#");
        messageHandler.setDefaultRetained(false);
        messageHandler.setDefaultQos(0);
        return messageHandler;
    }


}
