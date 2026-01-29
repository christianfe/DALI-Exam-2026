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

#### Dispatcher

| Event                | Type     | Source      |
|----------------------|----------|-------------|
| `call_emergency(Loc, Type)`        | external | environment |
| `report_emergency(Loc, Type)`          | external | Drone |


#### Drone

| Event                | Type     | Source      |
|----------------------|----------|-------------|
| `request_recognition(Loc)`        | external | Dispatcher      |
| `spot_fire(Loc)`          | external | environment      |
| `spot_accident(Loc)`   | external | environment      |
| `battery_low`     | Internal | drone   |


#### Ambulance 

| Event                | Type     | Source      |
|----------------------|----------|-------------|
| `dispatch(Loc)`        | external | Dispatcher      |
| `spot_fire(Loc)`          | external | environment      |

#### FireRescue 

| Event                | Type     | Source      |
|----------------------|----------|-------------|
| `dispatch(Loc)`        | external | Dispatcher      |
| `spot_accident(Loc)`          | external | environment      |


---

### 1.4 Action Table

#### Ambulance

| Action                      | Description                                 |
|-----------------------------|---------------------------------------------|
| `rescue_people`   | rescues people             |
| `report(emergency_retired)`   | Notifies the Dispatcher that evacuation is complete |

### Fireescue

| Action                      | Description                                 |
|-----------------------------|---------------------------------------------|
| `turn_off_fire`   | turn off the fire             |
| `report(emergency_retired)`   | Notifies the Dispatcher that evacuation is complete |

### Drone

| Action                      | Description                                 |
|-----------------------------|---------------------------------------------|
| `recharge`   | charge the battery             |

---

### 1.5 Agent Behaviors

- **Dispatcher**: reactive to emergencies; handles the operations.
- **Drone**: reactive to incoming alarms.
- **Ambulance**: reactive to emergency situations; proactive in evaluating the situation and ask for FireRescue support.
- **FireRescue**: reactive to emergency situations; proactive in evaluating the situation and ask for FireRescue support.

---




