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
    QProcess checkProcess;
    checkProcess.start("tasklist", QStringList() << "/FI" << "IMAGENAME eq tilt_osc.exe");
    checkProcess.waitForFinished();
    QString output = checkProcess.readAllStandardOutput();

    if (output.contains("tilt_osc.exe")) {
        return; // Don't staart another rinstance if TiltOSC is already running
    }

    QString scriptPath = QCoreApplication::applicationDirPath() + "/tilt_osc.exe";

    m_process = new QProcess(this);
    m_process->start(scriptPath);
}

void BackendManager::stopBackend()
{
    QProcess::execute("taskkill", QStringList() << "/IM" << "tilt_osc.exe" << "/F" << "/T");

    if (m_process != nullptr) {
        delete m_process;
        m_process = nullptr;
    }
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

    restartBackend();
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