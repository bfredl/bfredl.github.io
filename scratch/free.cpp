#include "s3/cam/free.hpp"

#include <cmath>
#include <glm/gtc/matrix_transform.hpp>

namespace s3::cams {

free::free(s3::window& w)
	: m_win(w),
	  m_pos(0, 0, 0),
	  m_facing(0, 0, -1.f),
	  m_ob(w),
	  m_mouse_x(0),
	  m_mouse_y(0),
	  m_mouse_px(0),
	  m_mouse_py(0) {

	m_ob.hook(evt::MOUSE_MOVE, [this](const evt::data& d) {
		m_mouse_x = (float)d.get<double>("x");
		m_mouse_y = (float)d.get<double>("y");
	});
}

free::~free() {
}

void free::update() {
	float dt = m_clock.restart().as_seconds();

	// getting mouse position diffs
	float mdx, mdy;
	mdx = m_mouse_px - m_mouse_x;
	mdy = m_mouse_py - m_mouse_y;

	// updating "prior" mouse position
	m_mouse_px = m_mouse_x;
	m_mouse_py = m_mouse_y;



	if (glfwGetKey(m_win.handle(), FORWARD_KEY) == GLFW_PRESS) {
		m_pos += m_facing * VEL * dt;
	} else if (glfwGetKey(m_win.handle(), BACKWARD_KEY) == GLFW_PRESS) {
		m_pos -= m_facing * VEL * dt;
	} else {
	}

	if (glfwGetKey(m_win.handle(), LEFT_KEY) == GLFW_PRESS) {
		m_pos += glm::normalize(glm::cross(UP, m_facing)) * VEL * dt;
	} else if (glfwGetKey(m_win.handle(), RIGHT_KEY) == GLFW_PRESS) {
		m_pos += glm::normalize(glm::cross(m_facing, UP)) * VEL * dt;
	} else {
	}

	if (glfwGetKey(m_win.handle(), UP_KEY) == GLFW_PRESS) {
		m_pos.y += dt * VEL;
	} else if (glfwGetKey(m_win.handle(), DOWN_KEY) == GLFW_PRESS) {
		m_pos.y -= dt * VEL;
	} else {
	}
}

glm::mat4 free::proj() const {
	return glm::perspective(glm::radians(45.0f), m_win.size().x / m_win.size().y, 0.1f, 100.f);
}

glm::mat4 free::view() const {
	return glm::lookAt(m_pos, m_pos + m_facing, UP);
}

}
