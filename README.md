# DALI_City_Rescue

A DALI multi-agent system coordinating a city rescue units designed according to the GAIA methodology guidelines.

Title: **Multi-Agent System for Emergency Management in a City**

## Objective

Design and implement a multi-agent system in the [DALI](https://github.com/AAAI-DISIM-UnivAQ/DALI) language for the detection and coordinated management of emergency events (e.g., fire, gas leak, earthquake) inside a smart building, following a simplified [**GAIA methodology**](https://link.springer.com/content/pdf/10.1023/A:1010071910869.pdf).

---

## Phase 1: Design according to the GAIA Methodology

### 1.1 Roles

| Role           | Main Responsibilities                        |
| -------------- | -------------------------------------------- |
| **Dispatcher** | Manage resorces, receive calls.              |
| **Drone**      | Detects crashes or fires over the city.      |
| **Ambulance**  | Rescue People, call Firerescue if necessary. |
| **FireRescue** | Turn Off fire, call ambulance if necessary.  |

---

### 1.2 Virtual Organization

- **Name**: `CityEmergencyManagementSystem`
- **Goals**:
    - Save people and turn off fires.
    - Ensure prompt and coordinated reaction to emergencies.
    - Emergency control.
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

| Event                         | Type     | Source      |
| ----------------------------- | -------- | ----------- |
| `call_emergency(Loc, Type)`   | external | environment |
| `report_emergency(Loc, Type)` | external | Drone       |

#### Drone

| Event                      | Type     | Source      |
| -------------------------- | -------- | ----------- |
| `request_recognition(Loc)` | external | Dispatcher  |
| `spot_fire(Loc)`           | external | environment |
| `spot_accident(Loc)`       | external | environment |
| `battery_check`              | Internal | drone       |

#### Ambulance

| Event                  | Type     | Source      |
| ---------------------- | -------- | ----------- |
| `dispatch(Loc)`        | external | Dispatcher  |
| `activate`                | external | Dispatcher   |
| `accept_dispatch(Loc)` | internal | ambulance   |
| `refuse_dispatch(Loc)` | internal | ambulance   |
| `move_to_job`       | internal | ambulance   |
| `do_rescue`       | internal | ambulance   |
| `return_base`       | internal | ambulance   |
| `maybe_end_shift`            | internal | ambulance   |
| `wakeup_check`               | internal | ambulance   |

#### FireRescue

| Event                | Type     | Source      |
| -------------------- | -------- | ----------- |
| `dispatch(Loc)`        | external | Dispatcher  |
| `activate`                | external | Dispatcher   |
| `accept_dispatch(Loc)` | internal | fireunit   |
| `refuse_dispatch(Loc)` | internal | fireunit   |
| `move_to_job`       | internal | fireunit   |
| `do_rescue`       | internal | fireunit   |
| `return_base`       | internal | fireunit   |
| `maybe_end_shift`            | internal | fireunit   |
| `wakeup_check`               | internal | fireunit   |


---

### 1.4 Action Table

#### Ambulance

| Action                      | Description                                         |
| --------------------------- | --------------------------------------------------- |
| `goto`             | move to the desired location                                   |
| `rescue_people` | rescue peoples and turn off fire |

### Fireescue

| Action                      | Description                                         |
| --------------------------- | --------------------------------------------------- |
| `goto`             | move to the desired location                                   |
| `rescue_people` | rescue peoples and turn off fire |

### Drone

| Action     | Description        |
| ---------- | ------------------ |
| `goto(Loc)` | move to the desired location |
| `recharge` | charge its battery |

---

### 1.5 Agent Behaviors

- **Dispatcher**: reactive to emergencies; handles the operations.
- **Drone**: reactive to incoming alarms.
- **Ambulance**: reactive to emergency situations; proactive in evaluating the situation and ask for FireRescue support.
- **FireRescue**: reactive to emergency situations; proactive in evaluating the situation and ask for FireRescue support.

---

### 1.6 Sequence Diagram

Here's a sequence diagram exploiting the agent interaction framework on emergency scenarios.

<br>

<img src="Sequence%20Diagram/DALI_sequence_sm.png" alt="Sequence diagram">


