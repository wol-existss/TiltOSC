//
// Created by grump on 29/08/2026.
//

#include "BackendManager.h"
#include <QCoreApplication>
#include <QFile>        // Needed to read, write, and manipulate JSON files.
#include <QJsonObject>
#include <QJsonDocument>
#include <QNetworkInterface>
#include <QDebug> // Remove me
#include <QUdpSocket>

BackendManager::BackendManager(QObject *parent) : QObject(parent) // Constructor
{
}



void BackendManager::startBackend()
{
    if (m_process != nullptr) {     // Returns if m_process is already pointing at a running process
        return;
    }

    QString scriptPath = QCoreApplication::applicationDirPath() + "/tilt_osc.exe"; // build text string to main.exe

    m_process = new QProcess(this);                                     // create QProcess object
    m_process->start(scriptPath); // Launch main.exe
}

void BackendManager::stopBackend()
{
    if (m_process == nullptr) {     // Returns if m_process isn't pointing at a running process
        return;
    }

    m_process->terminate();                 // Requests program to shut down
    m_process->waitForFinished(3000); // Waits 3 seconds for the backend to stop

    if (m_process->state() != QProcess::NotRunning) { // Kill forcefully if it hasn't closed after 3s
        m_process->kill();
    }

    delete m_process;   // free QProcess from memory
    m_process = nullptr;
}

void BackendManager::restartBackend() { // starts and stops main.py
    stopBackend();
    startBackend();
}



void BackendManager::saveSettings(int port, bool useLstick, bool useRstick, bool invertY, bool controllerEnabled)
{
    QJsonObject json; // Create empty JSON object in memory
    json["receive_port"] = port;                    // Save all settings to independent variables.
    json["use_digital_lstick"] = useLstick;
    json["use_digital_rstick"] = useRstick;
    json["invert_y_axis"] = invertY;
    json["controller_enabled"] = controllerEnabled;

    QJsonDocument doc(json); // Wrap QJsonObject into QJsonDocument

    QString configPath = QCoreApplication::applicationDirPath() + "/config.json";
    QFile file(configPath);
    if (file.open(QIODevice::WriteOnly)) {    // Open the file in write mode
        file.write(doc.toJson());   // Convert JSON document to text, wrrite to file
        file.close();
    }
}

void BackendManager::loadSettings()
{
    QString configPath = QCoreApplication::applicationDirPath() + "/config.json";
    QFile file(configPath);

    if (!file.open(QIODevice::ReadOnly)) {  // Opens JSON in read only moded
        return;
    }

    QByteArray data = file.readAll();   // Read entire JSON
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);  // Parse raw text into JSON doc
    QJsonObject json = doc.object();

    m_receivePort = json["receive_port"].toInt();       // Type converted to int because a port is an integer you dumb fuck
    m_useDigitalLstick = json["use_digital_lstick"].toBool();
    m_useDigitalRstick = json["use_digital_rstick"].toBool();
    m_invertYAxis = json["invert_y_axis"].toBool();
    m_controllerEnabled = json["controller_enabled"].toBool();

    emit settingsChanged(); // Notify QQML of changes
}

QString BackendManager::localIp() const
{
    QUdpSocket socket;
    socket.connectToHost(QHostAddress("8.8.8.8"), 53);
    if (socket.waitForConnected(100)) {
        QString ip = socket.localAddress().toString();
        socket.close();
        return ip;
    }
    return "No network detected!";
}