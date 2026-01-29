# DALI_City_Rescue

A DALI multi-agent system coordinating a city rescue units designed according to the GAIA methodology guidelines.

Title: __Multi-Agent System for Emergency Management in a City__

## Objective
Design and implement a multi-agent system in the [DALI](https://github.com/AAAI-DISIM-UnivAQ/DALI) language for the detection and coordinated management of emergency events (e.g., fire, gas leak, earthquake) inside a smart building, following a simplified  [**GAIA methodology**](https://link.springer.com/content/pdf/10.1023/A:1010071910869.pdf).

---

## Phase 1: Design according to the GAIA Methodology

### 1.1 Roles

| Role         | Main Responsibilities                                     |
|--------------|-----------------------------------------------------------|
| **Dispatcher**   | Manage resorces, receive calls.    |
| **Drone** | Detects crashes or fires over the city. |
| **Ambulance**| Rescue People, call Firerescue if necessary.                           |
| **FireRescue**   | Turn Off fire, call ambulance if necessary.           |

---

### 1.2 Virtual Organization

- **Name**: `CityEmergencyManagementSystem`
- **Goals**:
  - Save people and turn off fires.
  - Ensure prompt and coordinated reaction to emergencies.
  - Emergency control and escalation prevention.
- **Roles and Interactions**:
  - `Drone → Dispatcher`: sends alarm messages.
  - `Drone → Dispatcher`: inform about emergency type.
  - `Dispatcher → Drone`: report request about an emergency situation.
  - `Dispatcher → Ambulance`: dispatch to a location.
  - `Dispatcher → FireRescue`: dispatch to a location.
  - `Ambulance → Dispatcher`: request support
  - `FireRescue → Dispatcher`: request support

---

#TODO HERE

### 1.3 Event Table

#### Sensor

| Event                | Type     | Source      |
|----------------------|----------|-------------|
| `detect_smoke`        | external | environment |
| `detect_gas`          | external | environment |
| `detect_earthquake`   | external | environment |

#### Coordinator

| Event                | Type     | Source      |
|----------------------|----------|-------------|
| `alarm(smoke)`        | external | Sensor      |
| `alarm(gas)`          | external | Sensor      |
| `alarm(earthquake)`   | external | Sensor      |
| `evacuation_done`     | external | Evacuator   |

---

### 1.4 Action Table

#### Evacuator

| Action                      | Description                                 |
|-----------------------------|---------------------------------------------|
| `guide_people_to_exit(X)`   | Guides people to exit `X` safely            |
| `report(evacuation_done)`   | Notifies the Coordinator that evacuation is complete |

---

### 1.5 Agent Behaviors

- **Sensor**: reactive; generates alarms upon detecting anomalies.
- **Coordinator**: reactive to incoming alarms; proactive in managing the response strategy.
- **Evacuator**: reactive to evacuation commands; can report issues or confirmation.
- **Logger**: reactive; logs every received message or command.

---

